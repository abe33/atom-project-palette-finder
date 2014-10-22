_ = require 'underscore-plus'
fs = require 'fs'
url = require 'url'
path = require 'path'
Color = require 'pigments'
querystring = require 'querystring'
{Emitter} = require 'emissary'

[Palette, PaletteItem, ProjectPaletteView, ProjectColorsResultsView, ProjectColorsResultView] = []

class ProjectPaletteFinder
  @Color: Color
  Emitter.includeInto(this)

  @patterns: [
    '\\$[a-zA-Z0-9-_]+\\s*:'
    '@[a-zA-Z0-9-_]+\\s*:'
    '[a-zA-Z0-9-_]+\\s*='
  ]

  @filePatterns: [
    '**/*.sass'
    '**/*.scss'
    '**/*.less'
    '**/*.styl'
    '**/*.css'
  ]

  @grammarForExtensions:
    css: 'sass'
    sass: 'sass'
    scss: 'scss'
    less: 'less'
    styl: 'stylus'

  providers: []
  autocomplete: null

  config:
    autocompleteScopes:
      type: 'array'
      default: [
        'source.css'
        'source.css.less'
        'source.sass'
        'source.css.scss'
        'source.stylus'
      ]
      description: 'The palette provider will only complete color names in editors whose scope is present in this list.'
      items:
        type: 'string'

  constructor: ->
    @Color = Color

  activate: ({palette}) ->
    @scanProject()

    atom.workspaceView.command 'palette:refresh', => @scanProject()
    atom.workspaceView.command 'palette:view', => @displayView()
    atom.workspaceView.command 'palette:find-all-colors', => @findAllColors()

    atom.workspace.addOpener (uriToOpen) ->
      ProjectPaletteView ||= require './project-palette-view'

      {protocol, host} = url.parse uriToOpen
      return unless protocol is 'palette:' and host is 'view'

      new ProjectPaletteView

    atom.workspace.addOpener (uriToOpen) ->
      ProjectColorsResultsView ||= require './project-colors-results-view'

      {protocol, host} = url.parse uriToOpen
      return unless protocol is 'palette:' and host is 'search'

      new ProjectColorsResultsView

    pkg = atom.packages.getLoadedPackage("autocomplete-plus")
    if pkg?
      @autocomplete = pkg.mainModule
      @registerProviders()

  registerProviders: ->
    requestAnimationFrame =>
      PaletteProvider = require('./palette-provider')(@autocomplete)
      @editorSubscription = atom.workspaceView.eachEditorView (editorView) =>
        provider = new PaletteProvider editorView, this

        @autocomplete.registerProviderForEditorView provider, editorView

        @providers.push provider

  deactivate: ->
    @editorSubscription?.off()
    @editorSubscription = null

    @providers.forEach (provider) =>
      @autocomplete.unregisterProvider provider

    @providers = []

  serialize: ->
    {
      # palette: @palette.serialize()
    }

  displayView: ->
    @scanProject().then (palette) ->
      uri = "palette://view"

      pane = atom.workspace.paneContainer.paneForUri uri

      pane ||= atom.workspaceView.getActivePaneView().model

      atom.workspace.openUriInPane(uri, pane, {}).done (view) ->
        if view instanceof ProjectPaletteView
          view.setPalette palette

  scanProject: ->
    Palette ||= require './palette'
    PaletteItem ||= require './palette-item'

    @palette = new Palette

    filePatterns = @constructor.filePatterns
    results = []

    promise = atom.project.scan @getPatternsRegExp(), paths: filePatterns, (m) ->
      results.push m

    promise.then =>
      for {filePath, matches} in results
        for {lineText, matchText, range} in matches
          lineForMatch = lineText.replace(/\/\/.+$/, '')
          res = Color.searchColorSync(lineForMatch, matchText.length)
          if res?
            spaceBefore = lineForMatch[matchText.length...res.range[0]]
            spaceEnd = lineForMatch[res.range[1]..-1]
            continue unless spaceBefore.match /^\s*$/
            continue unless spaceEnd.match /^[\s;]*$/

            row = range[0][0]
            ext = filePath.split('.')[-1..][0]
            language = @constructor.grammarForExtensions[ext]
            @palette.addItem new PaletteItem {
              filePath
              row
              lineText
              language
              extension: ext
              name: matchText.replace /[\s=:]/g, ''
              lineRange: res.range
              colorString: res.match
            }

            items = @palette.items
            .map (item) ->
              _.escapeRegExp item.name
            .sort (a,b) ->
              b.length - a.length

            paletteRegexp = '(' + items.join('|') + ')(?!-|[ \\t]*[\\.:=])\\b'
            Color.removeExpression('palette')

            Color.addExpression 'palette', paletteRegexp, (color, expr) =>
              color.rgba = @palette.getItemByName(expr).color.rgba

      @emit 'palette:ready', @palette
      @palette

  findAllColors: ->
    Palette ||= require './palette'
    PaletteItem ||= require './palette-item'

    palette = new Palette

    filePatterns = @constructor.filePatterns.concat()

    results = []
    pendingResults = []

    re = new RegExp(Color.colorRegExp(), 'g')

    uri = "palette://search"

    pane = atom.workspace.paneContainer.paneForUri uri
    pane ||= atom.workspaceView.getActivePaneView().model

    view = null

    atom.workspace.openUriInPane(uri, pane, {}).done (v) ->
      view = v if v instanceof ProjectColorsResultsView

    promise = atom.project.scan re, paths: filePatterns, (m) =>
      for result in m.matches
        result.color = new Color(result.matchText)
        result.range[0][1] += result.matchText.indexOf(result.color.colorExpression)

      if view?
        if pendingResults.length > 0
          pendingResults.push m
          @createSearchResultForFile(r,view) for r in pendingResults
          pendingResults = []
        else
          @createSearchResultForFile(m,view)

      else
        pendingResults.push m

      results.push m

    promise.then =>
      for {filePath, matches} in results
        for {lineText, matchText, range} in matches
          ext = filePath.split('.')[-1..][0]
          palette.addItem new PaletteItem {
            filePath
            row: range[0][0]
            lineText
            language: @constructor.grammarForExtensions[ext]
            extension: ext
            name: matchText
            lineRange: range
            colorString: matchText
          }

      view.searchComplete()
      @emit 'palette:search-ready', palette
      palette

  createSearchResultForFile: (m, parentView) ->
    ProjectColorsResultView ||= require './project-colors-result-view'

    {filePath, matches} = m

    parentView.appendResult new ProjectColorsResultView(filePath, matches)

  getPatternsRegExp: ->
    new RegExp '(' + @constructor.patterns.join('|') + ')', 'gi'

module.exports = new ProjectPaletteFinder
