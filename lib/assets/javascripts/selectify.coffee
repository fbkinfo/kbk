$.selectify = (selector, options={}) ->
  entry = $(selector)

  defaults =
    render: {
      option_create: (data, escape_html)->
        '<div class="create">Добавить <strong>' + escape_html(data.input) + '</strong>&hellip;</div>'
    }

  entry.selectize $.extend(defaults, options)
