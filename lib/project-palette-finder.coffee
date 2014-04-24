_ = require 'underscore-plus'
fs = require 'fs'
path = require 'path'
Color = require 'pigments'
{Emitter} = require 'emissary'

Palette = require './palette'
PaletteItem = require './palette-item'

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
  ]

  activate: ({palette}) ->
    @palette = new Palette palette
    @scanProject()

    atom.workspaceView.command 'palette:refresh', => @scanProject()

  deactivate: ->

  serialize: ->
    {
      # palette: @palette.serialize()
    }

  scanProject: ->
    filePatterns = @constructor.filePatterns
    results = []
    promise = atom.project.scan @getPatternsRegExp(), paths: filePatterns, (m) ->
      results.push m

    promise.then =>
      for {filePath, matches} in results
        for {lineText, matchText, range} in matches
          res = Color.searchColorSync(lineText, matchText.length)
          if res?
            spaceBefore = lineText[matchText.length...res.range[0]]
            spaceEnd = lineText[res.range[1]..-1]
            continue unless spaceBefore.match /^\s*$/
            continue unless spaceEnd.match /^[\s;]*$/

            row = range[0][0]
            @palette.addItem new PaletteItem {
              filePath
              row
              name: matchText.replace /[\s=:]/g, ''
              lineRange: res.range
              colorString: res.match
            }

            items = @palette.items
            .map (item) ->
              _.escapeRegExp item.name
            .sort (a,b) ->
              b.length - a.length

            paletteRegexp = '(' + items.join('|') + ')(?!-|\\s*[\\.:=])\\b'
            Color.removeExpression('palette')

            Color.addExpression 'palette', paletteRegexp, (color, expr) =>
              color.rgba = @palette.getItemByName(expr).color.rgba

      @emit 'palette:ready', @palette

  getPatternsRegExp: ->
    new RegExp '(' + @constructor.patterns.join('|') + ')', 'gi'

module.exports = new ProjectPaletteFinder
