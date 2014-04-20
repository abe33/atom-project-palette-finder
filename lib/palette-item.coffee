Color = require 'pigments'

module.exports =
class PaletteItem
  constructor: ({@filePath, @row, @lineRange, @colorString}) ->
    @color = new Color @colorString

  serialize: ->
    {@filePath, @row, @range, @colorString}
