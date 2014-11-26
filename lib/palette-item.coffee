PropertyAccessors = require 'property-accessors'

module.exports = (Color) ->
  class PaletteItem
    PropertyAccessors.includeInto(this)

    @::accessor 'color', get: -> @_color ||= new Color @colorString

    constructor: ({@name, @filePath, @row, @lineRange, @lineText, @colorString, @language, @extension}) ->

    getRange: ->
      [[@row, @lineRange[0]], [@row, @lineRange[1]]]

    serialize: ->
      {@name, @filePath, @row, @lineRange, @lineText, @colorString, @language}
