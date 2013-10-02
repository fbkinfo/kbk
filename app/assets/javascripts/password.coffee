class PasswordValidator
  constructor: (fields)->
    fields.each (i, element)=>
      element = $(element)
      element.on 'keyup', =>
        @checkPassword(element)

  checkPassword: (element)=>
    password = element.val()
    return if password == ""

    result = zxcvbn(password)
    @renderAlert(element, result.entropy < 20.0)

  renderAlert: (element, alertVisible)->
    errorSpan = element.next("span.error")
    if errorSpan.length == 0
      errorSpan = $("<span class='error'></span>").insertAfter(element)

    submitButton = element.parents("form").find(".big-green-button")

    if alertVisible
      errorSpan.show()
      errorSpan.text("недостаточно сложный пароль")
      submitButton.attr("disabled", true)
    else
      errorSpan.hide()
      submitButton.removeAttr("disabled")


$ ->
  new PasswordValidator $("@password-input")
