{Emitter} = require 'emissary'
PaletteItem = require './palette-item'

module.exports =
class Palette
  Emitter.includeInto(this)

  constructor: ({items}={}) ->
    items ||= []
    @items = []

    for item in items
      @addItem new PaletteItem item

  addItem: (item) ->
    @items.push item unless item in @items

  removeItem: (item) ->
    if item in @items
      @items.splice @items.indexOf(item), 1

  serialize: -> { items: @items.map (i) -> i.serialize() }
