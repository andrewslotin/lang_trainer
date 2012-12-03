window.togglePasswordField = (link) ->
  type = if $('#password').attr("type") is "text" then "password" else "text"

  $("#password").each ->
    $('<input type="' + type + '"/>').attr
      name:  this.name,
      value: this.value,
      id:    this.id,
      class: this.className
    .insertBefore this
  .remove();
  $("i", link).toggleClass("icon-eye-open").toggleClass("icon-eye-close")