{ScrollView} = require 'atom-space-pen-views'
ProjectPaletteColorView = require './project-palette-color-view'

module.exports =
class CoffeeCompileView extends ScrollView
  @content: ->

    gridClass = 'btn'
    listClass = 'btn'

    displayMode = atom.config.get('project-palette-finder.paletteDisplay')
    if displayMode is 'list'
      listClass += ' selected'
    else
      gridClass += ' selected'

    @div class: 'palette tool-panel padded native-key-bindings', tabIndex: -1, =>
      @div class: 'palette-controls', =>
        @div class: 'inline-block btn-group', =>
          @button outlet: 'gridSwitch', class: gridClass, 'Grid'
          @button outlet: 'listSwitch', class: listClass, 'List'
        @div class: 'inline-block', =>
          inputAttrs =
            outlet: 'sortColors'
            type: 'checkbox'
            id: 'sort-colors'

          if atom.config.get('project-palette-finder.paletteSort')
            inputAttrs['checked'] = 'checked'
          @input inputAttrs
          @label for: 'sort-colors', 'Sort Colors'
        @div outlet: 'paletteStats', class: 'palette-stats inline-block'

      @div outlet: 'paletteColors', class: 'colors'

  initialize: ->
    @subscribe this, 'core:move-up', => @scrollUp()
    @subscribe this, 'core:move-down', => @scrollDown()

    @sorted = atom.config.get('project-palette-finder.paletteSort')

    @subscribe @gridSwitch, 'click', =>
      atom.config.set('project-palette-finder.paletteDisplay', 'grid')
      @gridSwitch.addClass 'selected'
      @listSwitch.removeClass 'selected'
      @paletteColors.addClass 'grid'

    @subscribe @listSwitch, 'click', =>
      atom.config.set('project-palette-finder.paletteDisplay', 'list')
      @gridSwitch.removeClass 'selected'
      @listSwitch.addClass 'selected'
      @paletteColors.removeClass 'grid'

    @subscribe @sortColors, 'change', =>
      @sorted = @sortColors[0].checked
      atom.config.set('project-palette-finder.paletteSort', @sorted)
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

    items = @palette.items.concat()

    console.log @palette.items

    if @sorted
      items.sort (a,b) => @compareColors(a,b)

    console.log items

    for item in items
      view = new ProjectPaletteColorView item
      @paletteColors.append view
