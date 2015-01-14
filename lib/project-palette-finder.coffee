EmitterMixin = require('emissary').Emitter
{Emitter, CompositeDisposable} = require 'event-kit'

[Palette, PaletteItem, ProjectPaletteView, ProjectColorsResultsView, ProjectColorsResultView, Color, deprecate, url, _] = []

class ProjectPaletteFinder
  EmitterMixin.includeInto(this)

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

    saveWatchersScopes:
      type: 'array'
      default: [
        'source.css.less'
        'source.sass'
        'source.css.scss'
        'source.stylus'
      ]
      description: 'When a buffer matching one of this scope is saved the palette is reloaded'
      items:
        type: 'string'

    paletteDisplay:
      type: 'string'
      default: 'list'
      enum: ['list', 'grid']

    paletteSort:
      type: 'boolean'
      default: false

  constructor: ->
    @Color = Color = require 'pigments'
    @emitter = new Emitter
    @subscriptions = new CompositeDisposable

  activate: ({palette}) ->
    atom.commands.add 'atom-workspace', {
      'palette:refresh': => @scanProject()
      'palette:view': => @displayView()
      'palette:find-all-colors': => @findAllColors()
    }

    atom.workspace.addOpener (uriToOpen) ->
      url ||= require 'url'
      ProjectPaletteView ||= require './project-palette-view'

      {protocol, host} = url.parse uriToOpen
      return unless protocol is 'palette:' and host is 'view'

      new ProjectPaletteView

    atom.workspace.addOpener (uriToOpen) ->
      url ||= require 'url'
      ProjectColorsResultsView ||= require './project-colors-results-view'

      {protocol, host} = url.parse uriToOpen
      return unless protocol is 'palette:' and host is 'search'

      new ProjectColorsResultsView

    @initializeWatchers()

    unless atom.inSpecMode()
      try atom.packages.activatePackage("autocomplete-plus").then (pkg) =>
        @autocomplete = pkg.mainModule
        @registerProviders()

    @scanProject()

  onDidUpdatePalette: (callback) ->
    @emitter.on 'did-update-palette', callback

  onDidFindColors: (callback) ->
    @emitter.on 'did-find-colors', callback

  on: (event, callback) ->
    deprecate ?= require('grim').deprecate
    switch event
      when 'palette:ready'
        deprecate('Use ProjectPaletteFinder::onDidUpdatePalette instead')
      when 'palette:search-ready'
        deprecate('Use ProjectPaletteFinder::onDidFindColors instead')

    EmitterMixin::on.call(this, event, callback)

  initializeWatchers: ->
    @subscriptions.add atom.config.observe 'project-palette-finder.saveWatchersScopes', (@saveWatchersScopes) =>

    @subscriptions.add atom.workspace.observeTextEditors (textEditor) =>
      subscriptions = new CompositeDisposable
      subscriptions.add textEditor.onDidDestroy -> subscriptions.dispose()
      subscriptions.add textEditor.onDidSave =>
        return unless textEditor.getGrammar().scopeName in @saveWatchersScopes
        @scanProject()

  registerProviders: ->
    requestAnimationFrame =>
      PaletteProvider = require('./palette-provider')(@autocomplete)

      if @autocomplete.registerProviderForEditor?
        @editorSubscription = atom.workspace.observeTextEditors (editor) =>
          provider = new PaletteProvider editor, this
          @autocomplete.registerProviderForEditor provider, editor

          @providers.push provider
      else
        # It falls back to the old registration method.
        @editorSubscription = atom.workspaceView.eachEditorView (editorView) =>
          provider = new PaletteProvider editorView, this
          @autocomplete.registerProviderForEditorView provider, editorView

          @providers.push provider

  deactivate: ->
    @subscriptions.dispose()
    @editorSubscription?.off()
    @editorSubscription = null

    @providers.forEach (provider) => @autocomplete.unregisterProvider provider

    @providers = []

  serialize: ->
    {
      # palette: @palette.serialize()
    }

  displayView: ->
    @scanProject().then (palette) ->
      uri = "palette://view"

      pane = atom.workspace.paneForURI(uri)
      pane ||= atom.workspace.getActivePane()

      atom.workspace.openURIInPane(uri, pane, {}).done (view) ->
        if view instanceof ProjectPaletteView
          view.setPalette palette
    .fail (reason) ->
      console.log reason

  scanProject: ->
    _ ||= require 'underscore-plus'
    Palette ||= require './palette'
    PaletteItem ||= require('./palette-item')(Color)

    palette = new Palette

    filePatterns = @constructor.filePatterns
    results = []

    promise = atom.workspace.scan @getPatternsRegExp(), paths: filePatterns, (m) ->
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
            palette.addItem new PaletteItem {
              filePath
              row
              lineText
              language
              extension: ext
              name: matchText.replace /[\s=:]/g, ''
              lineRange: res.range
              colorString: res.match
            }

            items = palette.items
            .map (item) ->
              _.escapeRegExp item.name
            .sort (a,b) ->
              b.length - a.length

            paletteRegexp = '(' + items.join('|') + ')(?!\\w|\\d|-|[ \\t]*[\\.:=])\\b'
            Color.removeExpression('palette')

            Color.addExpression 'palette', paletteRegexp, (color, expr) =>
              try
                color.rgba = palette.getItemByName(expr).color.rgba
              catch e
                console.log color, expr, palette.getItemByName(expr), palette

      @emit 'palette:ready', palette
      @emitter.emit 'did-update-palette', palette
      @palette = palette

    .fail (reason) ->
      console.log reason

  findAllColors: ->
    Palette ||= require './palette'
    PaletteItem ||= require './palette-item'

    palette = new Palette

    filePatterns = @constructor.filePatterns.concat()

    results = []
    pendingResults = []

    re = new RegExp(Color.colorRegExp(), 'g')

    uri = "palette://search"

    pane = atom.workspace.paneForURI(uri)
    pane ||= atom.workspace.getActivePane()

    view = null

    atom.workspace.openURIInPane(uri, pane, {}).then (v) ->
      view = v if v instanceof ProjectColorsResultsView

    promise = atom.workspace.scan re, paths: filePatterns, (m) =>
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
      @emitter.emit 'did-find-colors', palette
      palette

  createSearchResultForFile: (m, parentView) ->
    ProjectColorsResultView ||= require './project-colors-result-view'

    {filePath, matches} = m

    parentView.appendResult new ProjectColorsResultView(filePath, matches)

  getPatternsRegExp: ->
    new RegExp '(' + @constructor.patterns.join('|') + ')', 'gi'

module.exports = new ProjectPaletteFinder
