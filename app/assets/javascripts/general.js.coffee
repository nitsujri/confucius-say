$(document).keypress (e) -> 
  # Grab /
  unless $('#q').is(":focus")
    if e.which == 47 or e.which == 191 or e.which == 111
      $('#q').focus()
      e.preventDefault()

  # Grab Esc - not working, probably need to use keydown
  if e.which == 27
    alert "HIHI"
    $.blur()