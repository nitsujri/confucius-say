# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).keypress (e) -> 

    # Grab / or any key (slash will enter a slash without typing)
    unless $('#q').is(":focus")
      if e.which == 47 or e.which == 191 or e.which == 111
        $('#q').focus()
        e.preventDefault()
      else
        $('#q').focus()
      
    # Grab Esc - not working, probably need to use keydown
    if e.which == 27
      alert "HIHI"
      $.blur()

  #Textbox work ===============================
  # orig_text = $('.search_input').val()
  orig_text = "Search/Translate Words"

  $(".search_input").focus ->
    if $(this).val() == orig_text
      $(this).val("")

  $(".search_input").blur ->
    if $(this).val() == ""
      $(this).val(orig_text)

  #Example search links =======================
  $(".example-search").click ->
    $(".search_input").val($(this).html())
    $('#search-form').submit()
    false


  #PJAX =======================================
  $(document).on "submit", "form[data-pjax]", (event) ->
    $.pjax.submit event, "#main-content"


  #Search while typing ========================

  oldVal = $('#q').val()
  $("input").on "change keypress paste focus textInput input", ->
    val = @value
    if val isnt oldVal
      oldVal = val
      unless val.trim() == ""
        $('#search-form').submit()