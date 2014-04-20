{Emitter} = require 'emissary'
Color = require 'pigments'

Palette = require './palette'
PaletteItem = require './palette-item'

class ProjectPaletteFinder
  Emitter.includeInto(this)

  @patterns: [
    '\\$[a-zA-Z0-9-_]+\\s*:'
    '@[a-zA-Z0-9-_]+\\s*:'
    '[a-zA-Z0-9-_]+\\s*='
  ]

  @filePatterns: [
    '**/*.sass'
    '**/*.less'
    '**/*.styl'
  ]

  activate: ({palette}) ->
    @palette = new Palette palette
    @scanProject()

  deactivate: ->

  serialize: ->
    {
      palette: @palette.serialize()
    }

  scanProject: ->
    filePatterns = @constructor.filePatterns
    results = []
    promise = atom.project.scan @getPatternsRegExp(), filePatterns, (m) ->
      results.push m

    promise.then =>
      for {filePath, matches} in results
        for {lineText, lineOffset, matchText, range} in matches
          res = Color.searchColorSync(lineText, matchText.length)
          if res?
            row = range[0][0]
            @palette.addItem new PaletteItem {
              filePath
              row
              lineRange: res.range
              colorString: res.match
            }

      @emit 'palette:ready', @palette

  getPatternsRegExp: ->
    new RegExp '(' + @constructor.patterns.join('|') + ')', 'gi'

module.exports = new ProjectPaletteFinder
