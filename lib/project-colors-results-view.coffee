{ScrollView} = require 'atom'

module.exports =
class ProjectColorsResultsView extends ScrollView
  @content: ->
    @div class: 'preview-pane pane-item', =>
      @div class: 'panel-heading', =>
        @span outlet: 'previewCount', class: 'preview-count inline-block'
        @div outlet: 'loadingMessage', class: 'inline-block', =>
          @div class: 'loading loading-spinner-tiny inline-block'
          @div outlet: 'searchedCountBlock', class: 'inline-block', =>
            @span outlet: 'searchedCount', class: 'searched-count'
            @span ' paths searched'

      @ol outlet: 'resultsList', class: 'search-colors-results results-view list-tree focusable-panel has-collapsable-children', tabindex: -1

  initialize: ->
    super
    @files = 0
    @colors = 0

    @loadingMessage.hide()

  getTitle: -> 'Project Colors Search'
  getURI: -> 'palette://search'

  appendResult: (res) ->
    @files++
    @colors += res.results.length

    @resultsList.append(res)
    @previewCount.html("#{@colors} colors found in #{@files} files")
