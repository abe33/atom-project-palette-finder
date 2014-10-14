{View, Range} = require 'atom'

LeadingWhitespace = /^\s+/
removeLeadingWhitespace = (string) -> string.replace(LeadingWhitespace, '')

module.exports =
class MatchView extends View
  @content: ({filePath, match}) ->
    textColor = if match.color.luma() > 0.43
      'black'
    else
      'white'

    range = Range.fromObject(match.range)
    matchStart = range.start.column - match.lineTextOffset
    matchEnd = range.end.column - match.lineTextOffset
    prefix = removeLeadingWhitespace(match.lineText[0...matchStart])
    suffix = match.lineText[matchEnd..]

    @li class: 'search-result list-item', =>
      @span range.start.row + 1, class: 'line-number text-subtle'
      @span class: 'preview', outlet: 'preview', =>
        @span prefix
        @span match.matchText, class: 'match color-match', style: "background: #{match.color.toCSS()}; color: #{textColor};", outlet: 'matchText'
        @span suffix

  initialize: ({@filePath, @match}) ->
    if fontFamily = atom.config.get('editor.fontFamily')
      @preview.css('font-family', fontFamily)

  confirm: ->
    atom.workspaceView.open(@filePath, split: 'left').then (editor) =>
      editor.setSelectedBufferRange(@match.range, autoscroll: true)
