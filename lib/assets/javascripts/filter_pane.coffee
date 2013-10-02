class Slider
  constructor: (root) ->
    positionate = @positionate

    $('@handle', root).draggable
      revert: "invalid",
      axis: "x",
      containment: ".radio-slider"

    $('@entry', root)
      .droppable
        tolerance: "touch"
        drop: (e, ui) ->
          box = $(this)
          positionate $(this), ui.draggable, "fast", ->
            box.find('input').click()
      .each ->
        if $(this).find('input').is(':checked')
          box = $(this)
          positionate box, $('@handle', root), 0

  positionate: (box, element, duration, callback) ->
    props =
      top: box.position().top + 23 + "px"
      left: box.position().left + box.width() / 2 - element.width() / 2 + "px"

    element.animate props, duration, "swing", callback

class @FilterPane
  constructor: (root) ->
    root = $(root)
    @$   = (s) -> $(s, root)

    @slider = new Slider @$('@slider')
    @setupDateFields()
    @setupAutoSubmit()

  setupDateFields: ->
    @$('@date_selector select').change ->
      if $(@).val() == 'range'
        $(@).closest('@date_selector').hide().next('@date_range_picker').show()
    @$('@date_selector select').trigger('change')

    @$('@date_range_picker_close').click ->
      $(@).closest('@date_range_picker').hide().prev('@date_selector').show().find('select').val('').trigger('change')

  setupAutoSubmit: ->
    @$('@date_range_picker input').datepick 'option',
      onSelect: -> $(@).closest('form').submit()

    @$('select').change ->
      $(@).closest('form').submit() unless $(@).val() == 'range'

    @$('input[type=radio]').change ->
      $(@).closest('form').submit()

    @$('input[type=checkbox]').change ->
      $(@).closest('form').submit()

    @$('@submitter').keydown (e) ->
      if e.keyCode == 13
        e.preventDefault()
        $(this).closest('form').submit()