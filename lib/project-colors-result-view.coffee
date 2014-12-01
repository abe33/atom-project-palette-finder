_ = require 'underscore-plus'
fs = require 'fs-plus'
{$, View} = require 'atom-space-pen-views'
path = require 'path'
MatchView = require './match-view'

module.exports =
class ProjectColorsResultView extends View
  @content: (filePath, results) ->
    iconClass = if fs.isReadmePath(filePath) then 'icon-book' else 'icon-file-text'
    fileBasename = path.basename(filePath)

    @li class: 'path list-nested-item', 'data-path': _.escapeAttribute(filePath), =>
      @div outlet: 'pathDetails', class: 'path-details list-item', =>
        @span class: 'disclosure-arrow'
        @span class: iconClass + ' icon', 'data-name': fileBasename
        @span class: 'path-name bright', filePath.replace(atom.project.getPath()+path.sep, '')
        @span outlet: 'description', class: 'path-match-number'
      @ul outlet: 'matches', class: 'matches list-tree'

  initialize: (@filePath, @results) ->
    @isExpanded = true
    @renderResults(@filePath, @results)
    @pathDetails.on 'click', => @expand(not @isExpanded)

  renderResults: (filePath, results) ->
    @description.show().text("(#{results?.length})")

    for match in results
      @matches.append new MatchView({filePath, match})

  expand: (expanded) ->
    # expand or collapse the list
    if expanded
      @removeClass('collapsed')

      if @hasClass('selected')
        @removeClass('selected')
        firstResult = @find('.search-result:first').view()
        firstResult.addClass('selected')

        # scroll to the proper place
        resultView = firstResult.closest('.results-view').view()
        resultView.scrollTo(firstResult)

    else
      @addClass('collapsed')

      selected = @find('.selected').view()
      if selected?
        selected.removeClass('selected')
        @addClass('selected')

        resultView = @closest('.results-view').view()
        resultView.scrollTo(this)

      selectedItem = @find('.selected').view()

    @isExpanded = expanded

  confirm: ->
    @expand(not @isExpanded)
