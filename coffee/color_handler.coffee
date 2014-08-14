class ColorHandler
  constructor: ->
    @step = 3
    @total_steps = 32 #hard coded for convenience

  darken: (hex_color, step = @step)=> chroma(hex_color).darken(step).hex()
  brighten: (hex_color, step = @step)=> chroma(hex_color).brighten(step).hex()
  calculateInitialColor: (steps)->
    middle = (@total_steps / 2) - 1
    color = 'rgb(128, 128, 128)'
    steps = @total_steps if steps > @total_steps
    i = middle

    if steps < middle
      while i >= steps
        color = @brighten(color)
        i--
    else if steps > middle
      while i <= steps
        color = @darken(color)
        i++

    return color

