$ ->
  if $(".organizations-list").length > 0
    $(location.hash).effect "highlight", {times: 2}, 1500
