{ScrollView} = require 'atom'
ProjectPaletteColorView = require './project-palette-color-view'

module.exports =
class CoffeeCompileView extends ScrollView
  @content: ->
    @div class: 'palette tool-panel padded native-key-bindings', tabIndex: -1, =>
      @div class: 'palette-controls', =>
        @div class: 'inline-block btn-group', =>
          @button outlet: 'gridSwitch', class: 'btn', 'Grid'
          @button outlet: 'listSwitch', class: 'btn selected', 'List'
        @div class: 'inline-block', =>
          @input outlet: 'sortColors', type: 'checkbox', id: 'sort-colors'
          @label for: 'sort-colors', 'Sort Colors'
        @div outlet: 'paletteStats', class: 'palette-stats inline-block'

      @div outlet: 'paletteColors', class: 'colors'

  initialize: ->
    @subscribe this, 'core:move-up', => @scrollUp()
    @subscribe this, 'core:move-down', => @scrollDown()

    @subscribe @gridSwitch, 'click', =>
      @gridSwitch.addClass 'selected'
      @listSwitch.removeClass 'selected'
      @paletteColors.addClass 'grid'

    @subscribe @listSwitch, 'click', =>
      @gridSwitch.removeClass 'selected'
      @listSwitch.addClass 'selected'
      @paletteColors.removeClass 'grid'

    @subscribe @sortColors, 'change', =>
      @sorted = @sortColors.val()
      @buildColors()

  setPalette: (@palette) ->
    files = {}
    files[i.filePath] = i for i in @palette.items

    pluralize = (n, singular, plural) ->
      if n is 1
        "#{n} #{singular}"
      else
        "#{n} #{plural}"

    @paletteStats.html """
    <span class="text-info">#{pluralize @palette.items.length, 'color', 'colors'}</span>
    found accross
    <span class="text-info">#{pluralize Object.keys(files).length, 'file', 'files'}</span>
    """

    @buildColors()

  getTitle: -> 'Project Palette'
  getURI: -> 'palette://view'

  compareColors: (a,b) ->
    a = a._color
    b = b._color
    if a.hue < b.hue
      -1
    else if a.hue > b.hue
      1
    else if a.saturation < b.saturation
      -1
    else if a.saturation > b.saturation
      1
    else if a.lightness < b.lightness
      -1
    else if a.lightness > b.lightness
      1
    else
      0

  buildColors: ->
    @paletteColors.html('')

    items = @palette.items

    console.log items
    if @sorted
      items = items.sort (a,b) => @compareColors(a,b)
    console.log items

    for item in items
      view = new ProjectPaletteColorView item
      @paletteColors.append view
