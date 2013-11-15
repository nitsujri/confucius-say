# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = -> 
  $(".has-translation").mouseover ->
    $(".translation-bubble", this).show()
    $(this).css("z-index", 100)

  $(".has-translation").mouseout ->
    $(".translation-bubble", this).hide()
    $(this).css("z-index", 0)

$(document).ready(ready)
$(document).on('page:load', ready)