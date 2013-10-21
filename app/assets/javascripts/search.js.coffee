# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
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
    false

  # #Popup work
  # $(".bubbleInfo").each ->
    
  #   # options
  #   distance = 10
  #   time = 250
  #   hideDelay = 10
  #   hideDelayTimer = null
    
  #   # tracker
  #   beingShown = false
  #   shown = false
  #   trigger = $(".trigger", this)
  #   popup = $(".popup", this).css("opacity", 0)
    
  #   # set the mouseover and mouseout on both element
    
  #   # stops the hide event if we move from the trigger to the popup element
    
  #   # don't trigger the animation again if we're being shown, or already visible
    
  #   # reset position of popup box
  #   # brings the popup back in to view
    
  #   # (we're using chaining on the popup) now animate it's opacity and position
    
  #   # once the animation is complete, set the tracker variables
  #   $([trigger.get(0), popup.get(0)]).mouseover(->
  #     clearTimeout hideDelayTimer  if hideDelayTimer
  #     if beingShown or shown
  #       return
  #     else
  #       beingShown = true
  #       popup.css(
  #         top: 30
  #         left: 0
  #         display: "block"
  #       ).animate
  #         top: "-=" + distance + "px"
  #         opacity: 1
  #       , time, "swing", ->
  #         beingShown = false
  #         shown = true

  #   ).mouseout ->
      
  #     # reset the timer if we get fired again - avoids double animations
  #     clearTimeout hideDelayTimer  if hideDelayTimer
      
  #     # store the timer so that it can be cleared in the mouseover if required
  #     hideDelayTimer = setTimeout(->
  #       hideDelayTimer = null
  #       popup.animate
  #         top: "-=" + distance + "px"
  #         opacity: 0
  #       , time, "swing", ->
          
  #         # once the animate is complete, set the tracker variables
  #         shown = false
          
  #         # hide the popup entirely after the effect (opacity alone doesn't do the job)
  #         popup.css "display", "none"

  #     , hideDelay)


