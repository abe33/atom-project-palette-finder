module.exports = ({Provider, Suggestion}) ->
  fuzzaldrin = require 'fuzzaldrin'

  class PaletteProvider extends Provider
    constructor: (editor, @module) ->
      super(editor)

    wordRegex: /(@|\$)*\b\w*[a-zA-Z_]\w*\b/g
    buildSuggestions: ->
      return unless @editor.getGrammar().scopeName in atom.config.get('project-palette-finder.autocompleteScopes')
      selection = @editor.getSelection()
      prefix = @prefixOfSelection selection
      return unless prefix.length

      suggestions = []

      palette = @module.palette
      allNames = if palette.items then palette.items.map (i) -> i.name else []
      matchedNames = fuzzaldrin.filter allNames, prefix

      palette.items.forEach (item) =>
        return unless item.name in matchedNames
        suggestions.push new Suggestion(this, {
          word: item.name
          label: "<span class='color-suggestion-preview' style='background: #{item.color.toCSS()}'></span>"
          renderLabelAsHtml: true
          className: 'color-suggestion'
          prefix
        })

      suggestions
