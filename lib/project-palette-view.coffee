{ScrollView} = require 'atom'
ProjectPaletteColorView = require './project-palette-color-view'

module.exports =
class CoffeeCompileView extends ScrollView
  @content: ->
    @div class: 'palette tool-panel padded', tabIndex: -1, =>
      @div outlet: 'paletteColors', class: 'colors'

  constructor: ->
    super

    @subscribe this, 'core:move-up', => @scrollUp()
    @subscribe this, 'core:move-down', => @scrollDown()

  setPalette: (@palette) ->

    for item in @palette.items
      view = new ProjectPaletteColorView item
      @paletteColors.append view

  getTitle: -> 'Project Palette'
  getURI: -> 'palette://view'
