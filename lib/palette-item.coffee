Color = require 'pigments'

module.exports =
class PaletteItem
  constructor: ({@name, @filePath, @row, @lineRange, @colorString}) ->
    @color = new Color @colorString

  getRange: ->
    [[@row, @range[0]], [@row, @range[1]]]

  serialize: ->
    {@name, @filePath, @row, @range, @colorString}
