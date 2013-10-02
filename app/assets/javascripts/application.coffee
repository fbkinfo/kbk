#= require sugar-full
#= require jquery
#= require jquery_ujs
#= require jquery-ui
#= require jquery.role
#= require jquery.hashchange
#= require selectize
#= require jquery.datepick
#= require jquery.datepick-sugar
#= require jquery.datepick-ru
#= require jquery.fancybox
#= require plupload
#= require plupload.settings
#= require plupload.flash
#= require plupload.silverlight
#= require plupload.html4
#= require plupload.html5
#= require plupload.gears
#= require plupload.browserplus
#= require zxcvbn

#= require selectify
#= require filter_pane

#= require_self
#= require_tree .

Date.setLocale 'ru'

$ ->
  new FilterPane '.list-filter'

  $('@datepicker').datepick({
    onSelect: ->
      $(this).datepick('performAction', 'close')
      $(this).trigger('change')
  })

  $('@custom_select').each -> $.selectify this

  $('@content_togle').on 'click', ->
    $('@toggable_content').hide()
    $('@'+$(@).data('content')).show()

  $('@star').on 'change', ->
    id     = $(this).val()
    type = if $(this).is(':checked') then 'POST' else 'DELETE'
    $.ajax
      url: "/#{$(this).data('url')}/#{id}/star"
      type: type


