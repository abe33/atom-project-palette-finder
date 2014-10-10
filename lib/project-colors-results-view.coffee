{ScrollView} = require 'atom'

module.exports =
class ProjectColorsResultsView extends ScrollView
  @content: ->
    @div class: 'search-colors-results'

  initialize: ->
