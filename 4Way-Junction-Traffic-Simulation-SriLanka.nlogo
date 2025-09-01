globals [counter cycle-end?]

breed[cars car]
breed[lights light]


cars-own[
  speed
  destination
  action
]

lights-own[
  name
  cars-passed
  density-num
]

patches-own[
  meaning
]

to set-sides
 set side1 10
 set side2 10
 set side3 10
 set side4 10
end

to setup
 ca
 reset-ticks
 clear-output
 draw-road
 place-cars
 place-lights
 set cycle-end? false
 set-sides
end

to draw-road
  ask patches [
    set pcolor white - 2
    set meaning "blank"
    if abs pxcor <= 6 or abs pycor <= 6
    [
      set pcolor brown + 1
      set meaning "crossroad"
    ]
    if abs pxcor <= 4 or abs pycor <= 4
    [
      set pcolor gray - 1
      set meaning "junction"
    ]
    let coordinates [[5 5] [5 -5] [-5 5] [-5 -5] [5 6] [6 5] [-5 6] [-6 -5] [5 -6] [-6 5] [-5 -6] [6 -5]]
    foreach coordinates [
      [coord] ->
        let x item 0 coord
        let y item 1 coord
        ask patch x y [
          set pcolor gray - 1
          ;set meaning "road-up"
        ]
    ]

   ask patches with [ pxcor = -3] [set meaning "lane-one" ]
   ask patches with [ pxcor = -1] [set meaning "lane-two" ]
   ask patches with [ pycor = -3] [set meaning "lane-three" ]
   ask patches with [ pycor = -1 ] [set meaning "lane-four" ]
   ask patches with [ pxcor = 3 ] [set meaning "lane-five" ]
   ask patches with [ pxcor = 1] [set meaning "lane-six" ]
   ask patches with [ pycor = 3] [set meaning "lane-seven" ]
   ask patches with [ pycor = 1] [set meaning "lane-eight" ]


  ]


  let half-side-length 5  ;; Half the side length of the square
  let color-to-use gray - 1  ;; Color to use for the square

  ;; Loop over x and y coordinates to cover the square area
  ask patches with [
    abs pxcor <= half-side-length and abs pycor <= half-side-length
  ] [
    set pcolor color-to-use
  ]

  draw-road-lines

end

to draw-road-lines
  let lanes 2
  set lanes n-values 4 [n -> 4 - (n * 2) - 1 ]
  let y (last lanes) - 1 ; start below the "lowest" lane
  while [ y <= first lanes + 1 ] [
    if not member? y lanes [
      ; draw lines on road patches that are not part of a lane
      let gap-vertical ifelse-value (abs y = 2) [0.5] [0]
      let gap-horizontal ifelse-value (abs y = 2) [0.5] [0]

      draw-line y 0 white gap-vertical (world-height / 2 - 7) ; vertical line ending in the middle
      draw-line y 180 white gap-vertical (world-height / 2 - 7)  ; vertical line ending in the middle
      draw-line y 90 white gap-horizontal (world-width / 2 - 7)  ; horizontal line ending in the middle
      draw-line y 270 white gap-horizontal (world-width / 2 - 7) ; horizontal line ending in the middle


    ]
    set y y + 1 ; move up one patch
  ]
end

to draw-line [coord direction line-color gap len]
  ; We use a temporary turtle to draw the line:
  ; - with a gap of zero, we get a continuous line;
  ; - with a gap greater than zero, we get a dashed line.
  create-turtles 1 [
    if direction = 90 or direction = 270 [
      setxy (min-pxcor - 0.5) coord
    ]
    if direction = 0 or direction = 180 [
      setxy coord (min-pycor - 0.5)
    ]
    hide-turtle
    set color line-color
    set heading direction
    let steps len
    while [steps > 0] [
      pen-up
      forward gap
      pen-down
      forward (1 - gap)
      set steps steps - 1
    ]
    die
  ]

end

to place-cars

  ask n-of (lane-one-population) patches with [meaning = "lane-one" and count turtles-on neighbors = 0] [
    if not any? cars-on patch (pxcor + 1) pycor and not any? cars-here and not any? cars-on patch (pxcor - 1) pycor [
      sprout-cars 1 [
        set heading 0
        set destination one-of ["left"  "forward"]
        ]
    ]
  ]

  ask n-of (lane-two-population) patches with [meaning = "lane-two" and count turtles-on neighbors = 0 ] [
    if not any? cars-on patch (pxcor + 1) pycor and not any? cars-here and not any? cars-on patch (pxcor - 1) pycor [
      sprout-cars 1 [
        set heading 0
        set destination "right"
      ]
    ]
  ]

  ask n-of (lane-three-population) patches with [meaning = "lane-three" and count turtles-on neighbors = 0] [
    if not any? cars-on patch (pxcor + 1) pycor and not any? cars-here and not any? cars-on patch (pxcor - 1 ) pycor [
      sprout-cars 1 [
        set heading 270
        set destination one-of ["left"  "forward"]
      ]
    ]
  ]

  ask n-of (lane-four-population) patches with [meaning = "lane-four" and count turtles-on neighbors = 0] [
    if not any? cars-on patch (pxcor + 1) pycor and not any? cars-here and not any? cars-on patch (pxcor - 1) pycor [
      sprout-cars 1 [
        set heading 270
        set destination "right"
      ]
    ]
  ]

  ask n-of (lane-five-population) patches with [meaning = "lane-five" and count turtles-on neighbors = 0] [
    if not any? cars-on patch (pxcor + 1) pycor and not any? cars-here and not any? cars-on patch (pxcor - 1) pycor [
      sprout-cars 1 [
        set heading 180
        set destination one-of ["left"  "forward"]
      ]
    ]
  ]

  ask n-of (lane-six-population) patches with [meaning = "lane-six" and count turtles-on neighbors = 0] [
    if not any? cars-on patch (pxcor + 1) pycor and not any? cars-here and not any? cars-on patch (pxcor - 1) pycor [
      sprout-cars 1 [
        set heading 180
        set destination "right"
      ]
    ]
  ]

  ask n-of (lane-seven-population) patches with [meaning = "lane-seven" and count turtles-on neighbors = 0 ] [
    if not any? cars-on patch (pxcor + 1) pycor and not any? cars-here and not any? cars-on patch (pxcor - 1) pycor [
      sprout-cars 1 [
        set heading 90
        set destination one-of ["left"  "forward"]
      ]
    ]
  ]

  ask n-of (lane-eight-population) patches with [meaning = "lane-eight" and count turtles-on neighbors = 0] [
    if not any? cars-on patch (pxcor + 1) pycor and not any? cars-here and not any? cars-on patch (pxcor - 1) pycor [
      sprout-cars 1 [
        set heading 90
        set destination "right"
      ]
    ]
  ]

  ask cars [
    set size 1
    set shape "car top"
    set action "moving"
    set speed 0.1
  ]

end

to place-lights
  ask patch -3 -5 [
    sprout-lights 1 [
        set shape "light-straight"
        set name "S1"
        set heading 0
      ]
  ]

  ask patch -1 -5 [
    sprout-lights 1 [
        set shape "light-right"
        set name "S2"
        set heading 0
        set size 1
      ]
  ]

  ask patch 5 -3 [
    sprout-lights 1 [
        set shape "light-straight"
        set name "S3"
        set heading 270
        set size 1
      ]
  ]

  ask patch 5 -1 [
    sprout-lights 1 [
        set shape "light-right"
        set name "S4"
        set heading 270
        set size 1
      ]
  ]

  ask patch 3 5 [
    sprout-lights 1 [
        set shape "light-straight"
        set name "S5"
        set heading 180
        set size 1
      ]
  ]

  ask patch 1 5 [
    sprout-lights 1 [
        set shape "light-right"
        set name "S6"
        set heading 180
        set size 1
      ]
  ]

  ask patch -5 3 [
    sprout-lights 1 [
        set shape "light-straight"
        set name "S7"
        set heading 90
      set size 1
      ]
  ]

  ask patch -5 1 [
    sprout-lights 1 [
        set shape "light-right"
        set name "S8"
        set heading 90
      set size 1
      ]
  ]



  ;left lights
  ask patch -6 -6 [
    sprout-lights 1 [
      set heading 0
      set shape "light-left"
    ]
  ]

  ask patch 6 -6 [
    sprout-lights 1 [
      set heading 270
      set shape "light-left"
    ]
  ]

  ask patch 6 6 [
    sprout-lights 1 [
      set heading 180
      set shape "light-left"
    ]
  ]

  ask patch -6 6 [
    sprout-lights 1 [
      set heading 90
      set shape "light-left"
    ]
  ]

  set-off-peak
end

to set-off-peak
    ask lights [
    set color orange
    set label "off-peak"
  ]
end

to go
  tick
  move-cars
  set cycle side1 + side2 + side3 + side4

  ;; peak, off-peak controlling
  ifelse peak = true  [ control-traffic-lights ] [ set-off-peak ]

  ;; for troubleshooting
  if any? cars with [meaning = "blank"][
    user-message "Simulation Failed! "
    stop
  ]

  ;; deadlock detection
  if all? cars [speed = 0] and deadlock-detection = true [
   user-message "Deadlock detected! Simulation will stop."
   stop
  ]

  ;; making simulation smooth or fast visibly
  if visible-speed = true [
    wait 0.1
  ]

  ask lights [
  if color = green [
    let num-cars-here count cars with [pxcor = [pxcor] of myself and pycor = [pycor] of myself]
    if num-cars-here > 0 [
        set cars-passed cars-passed + num-cars-here
        set density-num density-num + num-cars-here
      ]
    ]
  ]

  if ticks mod 10 = 0 [ ;; one second checkin
    set counter counter + 1
    ;output-print (word "Counter"  counter )
    ask lights with [color = green] [
      set density-num 0
    ]

  ]
end

to go-cycle
  ask lights [ set cars-passed 0 ]
  set cycle-end? false  ;; Reset cycle-end? to false at the beginning
  while [not cycle-end?] [  ;; Run the loop until cycle-end? becomes true
    go
  ]
end


to-report is-at-coordinates? [coords]
  report pxcor = item 0 coords and pycor = item 1 coords
end

to die-at-the-end
  ;; Define the list of coordinate pairs to check
    let die-coordinates [[-30 -3] [-30 -1] [-3 18] [-1 -18] [30 3] [30 1] [3 -18] [1 -18]]

    ;; Check if the turtle's coordinates match any of the specified pairs
    foreach die-coordinates [coords ->
     if is-at-coordinates? coords [
      die
      ]
    ]
end

to move-cars
  ; turn left
  ask cars [
    let turn-left-coordinates [[-3 -7] [-7 3] [3 7] [7 -3]]
    foreach turn-left-coordinates [coords ->
      if is-at-coordinates? coords  [
        if destination = "left" and action = "moving" [
        set heading heading - 45
        set action "turning"
        ]
      ]
    ]

    ; turn left to straght
    let turn-left-to-straight-coordinates [[-7 -3][-8 -3][-3 7][-3 8] [7 3][8 3] [3 -7] [3 -8]]
    foreach turn-left-to-straight-coordinates [coords ->
      if is-at-coordinates? coords  [
        if destination = "left" and action = "turning" [
        set heading heading - 45
        set action "moving"
        ]
      ]
    ]

    ; turn right
    let turn-right-coordinates [[-1 -5] [5 -1] [1 5] [-5 1]]
    foreach turn-right-coordinates [coords ->
      if is-at-coordinates? coords  [
        if destination = "right" and action = "moving" [
        set heading heading + 45
        set action "turning"
        ]
      ]
    ]

    ; turn right to straight
    let turn-right-to-straight-coordinates [[5 1] [6 1] [-1 5][-1 6] [1 -5] [1 -6] [-5 -1] [-6 -1]]
    foreach turn-right-to-straight-coordinates [coords ->
      if is-at-coordinates? coords  [
        if destination = "right" and action = "turning" [
        set heading heading + 45
        set action "moving"
        ]
      ]
    ]


    ;whether traffic lights show red or green
    ifelse any? (lights-on patch-ahead 1) with [color = red]
    [
      set speed 0
    ]
    [
      ifelse action = "turning" [
        control-speed-when-turning
      ] [
        if action = "moving" [
          control-speed
        ]
      ]
    ]

      ; Wraping the world
    if wrap-world != true [
      die-at-the-end
    ]
]
end

to control-speed-when-turning
  let car-ahead one-of cars-on patch-ahead 1.5
  ifelse car-ahead != nobody  [
   ifelse [speed] of car-ahead <= 0.1 [
      set speed 0
    ] [
      if [speed] of car-ahead >= 0.2 [
        set speed 0.1
      ]
    ]
  ]
  [
    set speed 0.4
  ]
  fd speed
end

to control-speed
  let car-ahead one-of cars-on patch-ahead 1.5
  ifelse car-ahead = nobody  [
    if speed < 0.3 [
      set speed speed + 0.1
    ]
      fd speed
  ]
  [
    ifelse [speed] of car-ahead = 0 [
      set speed 0
    ] [
      if [speed] of car-ahead >= 0.3 [
        set speed 0.1
      ]
    ]
  ]
  fd speed
end

to control-traffic-lights
  if routes-combinations = "com1" [ combination-one ] ;; 'com1': ['R12', 'R34', 'R56', 'R78']
  if routes-combinations = "com2" [ combination-two ] ;; 'com2': ['R12', 'R37', 'R48', 'R56']
  if routes-combinations = "com3" [ combination-three ] ;; 'com3': ['R14', 'R26', 'R37', 'R58']
  if routes-combinations = "com4" [ combination-four ] ;;  'com4': ['R14', 'R27', 'R36', 'R58']
  if routes-combinations = "com5" [ combination-five ] ;; 'com5': ['R15', 'R26', 'R34', 'R78']
  if routes-combinations = "com6" [ combination-six ] ;;  'com6': ['R15', 'R26', 'R37', 'R48']
  if routes-combinations = "com7" [ combination-seven ] ;; 'com7': ['R15', 'R27', 'R36', 'R48']
end

to-report both? [agentset]
  report all? agentset [density-num < min-density]
end

to combination-one  ;;'com1': ['R12', 'R34', 'R56', 'R78']
  ;; side 1 (Mode 1) R12
  if counter <= side1 [
    change-color lights with [name = "S1"] green
    change-color lights with [name = "S2"] green
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 - counter ]
    ask lights with [name = "S3" or name = "S4"] [ set label side1 - counter ]
    ask lights with [name = "S5" or name = "S6"] [ set label side1 + side2 - counter ]
    ask lights with [name = "S7" or name = "S8"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check both? lights with [color = green and density-num < min-density]
    if check [
        set side1 counter
      ]
    ]

  ]

  ;;Output
  if counter = side1 and ticks mod 10 = 0 [
    output-print (word "side1-counter " side1 word " : S1 "   [cars-passed] of one-of lights with [name = "S1"] word "  S2 "  [cars-passed] of one-of lights with [name = "S2"])
  ]

  ;; side 2 (Mode 2)
  if counter > side1 and counter <= side1 + side2 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] green
    change-color lights with [name = "S4"] green
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 + side2 - counter  ]
    ask lights with [name = "S1" or name = "S2"] [ set label cycle - counter ]
    ask lights with [name = "S5" or name = "S6"] [ set label side1 + side2 - counter ]
    ask lights with [name = "S7" or name = "S8"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
     let check both? lights with [color = green and density-num < min-density]
    if check [
        set side2 counter - side1
      ]
    ]

  ]

  ;;Output
  if counter = side1 + side2 and ticks mod 10 = 0 [
     output-print (word "side2-counter " side2 word " : S3 "   [cars-passed] of one-of lights with [name = "S3"] word "  S4 "  [cars-passed] of one-of lights with [name = "S4"] )
  ]

 ;; side 3 (Mode 3)
 if counter > side1 + side2 and counter <= side1 + side2 + side3 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] green
    change-color lights with [name = "S6"] green
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 + side2 + side3 - counter ]
    ask lights with [name = "S1" or name = "S2"] [ set label cycle - counter ]
    ask lights with [name = "S3" or name = "S4"] [ set label cycle + side1 - counter ]
    ask lights with [name = "S7" or name = "S8"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side3 counter - side1 - side2
      ]
    ]

  ]

  ;;Output
  if counter = side1 + side2 + side3 and ticks mod 10 = 0 [
     output-print (word "side3-counter " side3 word " : S5 "   [cars-passed] of one-of lights with [name = "S5"] word "  S6 "  [cars-passed] of one-of lights with [name = "S6"] )
  ]


  ;; side 4 (Mode 4)
  if counter > side1 + side2 + side3 and counter <= side1 + side2 + side3 + side4 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] green
    change-color lights with [name = "S8"] green

    ask lights with [color = green] [ set label side1 + side2 + side3 + side4 - counter ]
    ask lights with [name = "S1" or name = "S2"] [ set label cycle - counter ]
    ask lights with [name = "S3" or name = "S4"] [ set label cycle + side1 - counter ]
    ask lights with [name = "S5" or name = "S6"] [ set label cycle + side1 + side2 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side4 counter - side1 - side2 - side3
      ]
    ]

  ]

  if counter = side1 + side2 + side3 + side4 [
    output-print (word "side4-counter " side4 word " : S7 "   [cars-passed] of one-of lights with [name = "S7"] word "  S8 "  [cars-passed] of one-of lights with [name = "S8"] )
    output-print(word "Cycle Finished at " (ticks / 10) " in com1")
    set counter 0
    set cycle-end? true

  ]

  ask lights with[color = orange] [set label ""]
end

to combination-two  ;; 'com2': ['R12', 'R37', 'R48', 'R56']
  ;; side 1 (Mode 1) R12
  if counter <= side1 [
    change-color lights with [name = "S1"] green
    change-color lights with [name = "S2"] green
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 - counter ]
    ask lights with [name = "S3" or name = "S7"] [ set label side1 - counter ]
    ask lights with [name = "S4" or name = "S8"] [ set label side1 + side2 - counter ]
    ask lights with [name = "S5" or name = "S6"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side1 counter
      ]
    ]

  ]

  ;;Output
  if counter = side1 and ticks mod 10 = 0 [
    output-print (word "side1-counter " side1 word " : S1 "   [cars-passed] of one-of lights with [name = "S1"] word "  S2 "  [cars-passed] of one-of lights with [name = "S2"])
  ]

  ;; side 2 (Mode 2) R37
  if counter > side1 and counter <= side1 + side2 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] green
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] green
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 + side2 - counter  ]
    ask lights with [name = "S1" or name = "S2"] [ set label cycle - counter ]
    ask lights with [name = "S4" or name = "S8"] [ set label side1 + side2 - counter ]
    ask lights with [name = "S5" or name = "S6"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side2 counter - side1
      ]
    ]

  ]

  ;;Output
  if counter = side1 + side2 and ticks mod 10 = 0 [
     output-print (word "side2-counter " side2 word " : S3 "   [cars-passed] of one-of lights with [name = "S3"] word "  S7 "  [cars-passed] of one-of lights with [name = "S7"] )
  ]

 ;; side 3 (Mode 3) R48
 if counter > side1 + side2 and counter <= side1 + side2 + side3 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] green
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] green

    ask lights with [color = green] [ set label side1 + side2 + side3 - counter ]
    ask lights with [name = "S1" or name = "S2"] [ set label cycle - counter ]
    ask lights with [name = "S3" or name = "S7"] [ set label cycle + side1 - counter ]
    ask lights with [name = "S5" or name = "S6"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side3 counter - side1 - side2
      ]
    ]

  ]

  ;;Output
  if counter = side1 + side2 + side3 and ticks mod 10 = 0 [
     output-print (word "side3-counter " side3 word " : S4 "   [cars-passed] of one-of lights with [name = "S4"] word "  S8 "  [cars-passed] of one-of lights with [name = "S8"] )
  ]


  ;; side 4 (Mode 4) R56
  if counter > side1 + side2 + side3 and counter <= side1 + side2 + side3 + side4 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] green
    change-color lights with [name = "S6"] green
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 + side2 + side3 + side4 - counter ]
    ask lights with [name = "S1" or name = "S2"] [ set label cycle - counter ]
    ask lights with [name = "S3" or name = "S7"] [ set label cycle + side1 - counter ]
    ask lights with [name = "S4" or name = "S8"] [ set label cycle + side1 + side2 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side4 counter - side1 - side2 - side3
      ]
    ]

  ]

  if counter = side1 + side2 + side3 + side4 [
    output-print (word "side4-counter " side4 word " : S5 "   [cars-passed] of one-of lights with [name = "S5"] word "  S6 "  [cars-passed] of one-of lights with [name = "S6"] )
    output-print(word "Cycle Finished at " (ticks / 10) " in com2")
    set counter 0
    set cycle-end? true

  ]

  ask lights with[color = orange] [set label ""]
end

to combination-three  ;; 'com3': ['R14', 'R26', 'R37', 'R58']
  ;; side 1 (Mode 1) R14
  if counter <= side1 [
    change-color lights with [name = "S1"] green
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] green
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 - counter ]
    ask lights with [name = "S2" or name = "S6"] [ set label side1 - counter ]
    ask lights with [name = "S3" or name = "S7"] [ set label side1 + side2 - counter ]
    ask lights with [name = "S5" or name = "S8"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side1 counter
      ]
    ]

  ]

  ;;Output
  if counter = side1 and ticks mod 10 = 0 [
    output-print (word "side1-counter " side1 word " : S1 "   [cars-passed] of one-of lights with [name = "S1"] word "  S4 "  [cars-passed] of one-of lights with [name = "S4"])
  ]

  ;; side 2 (Mode 2) R26
  if counter > side1 and counter <= side1 + side2 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] green
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] green
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 + side2 - counter  ]
    ask lights with [name = "S1" or name = "S4"] [ set label cycle - counter ]
    ask lights with [name = "S3" or name = "S7"] [ set label side1 + side2 - counter ]
    ask lights with [name = "S5" or name = "S8"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side2 counter - side1
      ]
    ]

  ]

  ;;Output
  if counter = side1 + side2 and ticks mod 10 = 0 [
     output-print (word "side2-counter " side2 word " : S2 "   [cars-passed] of one-of lights with [name = "S2"] word "  S6 "  [cars-passed] of one-of lights with [name = "S6"] )
  ]

 ;; side 3 (Mode 3) R37
 if counter > side1 + side2 and counter <= side1 + side2 + side3 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] green
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] green
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 + side2 + side3 - counter ]
    ask lights with [name = "S1" or name = "S4"] [ set label cycle - counter ]
    ask lights with [name = "S2" or name = "S6"] [ set label cycle + side1 - counter ]
    ask lights with [name = "S5" or name = "S8"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side3 counter - side1 - side2
      ]
    ]

  ]

  ;;Output
  if counter = side1 + side2 + side3 and ticks mod 10 = 0 [
     output-print (word "side3-counter " side3 word " : S3 "   [cars-passed] of one-of lights with [name = "S3"] word "  S7 "  [cars-passed] of one-of lights with [name = "S7"] )
  ]


  ;; side 4 (Mode 4) R58
  if counter > side1 + side2 + side3 and counter <= side1 + side2 + side3 + side4 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] green
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] green

    ask lights with [color = green] [ set label side1 + side2 + side3 + side4 - counter ]
    ask lights with [name = "S1" or name = "S4"] [ set label cycle - counter ]
    ask lights with [name = "S2" or name = "S6"] [ set label cycle + side1 - counter ]
    ask lights with [name = "S3" or name = "S7"] [ set label cycle + side1 + side2 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side4 counter - side1 - side2 - side3
      ]
    ]

  ]

  if counter = side1 + side2 + side3 + side4 [
    output-print (word "side4-counter " side4 word " : S5 "   [cars-passed] of one-of lights with [name = "S5"] word "  S8 "  [cars-passed] of one-of lights with [name = "S8"] )
    output-print(word "Cycle Finished at " (ticks / 10) " in com3")
    set counter 0
    set cycle-end? true

  ]

  ask lights with[color = orange] [set label ""]
end

to combination-four  ;; 'com4': ['R14', 'R27', 'R36', 'R58']
  ;; side 1 (Mode 1) R14
  if counter <= side1 [
    change-color lights with [name = "S1"] green
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] green
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 - counter ]
    ask lights with [name = "S2" or name = "S7"] [ set label side1 - counter ]
    ask lights with [name = "S3" or name = "S6"] [ set label side1 + side2 - counter ]
    ask lights with [name = "S5" or name = "S8"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side1 counter
      ]
    ]

  ]

  ;;Output
  if counter = side1 and ticks mod 10 = 0 [
    output-print (word "side1-counter " side1 word " : S1 "   [cars-passed] of one-of lights with [name = "S1"] word "  S4 "  [cars-passed] of one-of lights with [name = "S4"])
  ]

  ;; side 2 (Mode 2) R27
  if counter > side1 and counter <= side1 + side2 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] green
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] green
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 + side2 - counter  ]
    ask lights with [name = "S1" or name = "S4"] [ set label cycle - counter ]
    ask lights with [name = "S3" or name = "S6"] [ set label side1 + side2 - counter ]
    ask lights with [name = "S5" or name = "S8"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side2 counter - side1
      ]
    ]

  ]

  ;;Output
  if counter = side1 + side2 and ticks mod 10 = 0 [
     output-print (word "side2-counter " side2 word " : S2 "   [cars-passed] of one-of lights with [name = "S2"] word "  S7 "  [cars-passed] of one-of lights with [name = "S7"] )
  ]

 ;; side 3 (Mode 3) R36
 if counter > side1 + side2 and counter <= side1 + side2 + side3 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] green
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] green
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 + side2 + side3 - counter ]
    ask lights with [name = "S1" or name = "S4"] [ set label cycle - counter ]
    ask lights with [name = "S2" or name = "S7"] [ set label cycle + side1 - counter ]
    ask lights with [name = "S5" or name = "S8"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side3 counter - side1 - side2
      ]
    ]

  ]

  ;;Output
  if counter = side1 + side2 + side3 and ticks mod 10 = 0 [
     output-print (word "side3-counter " side3 word " : S3 "   [cars-passed] of one-of lights with [name = "S3"] word "  S6 "  [cars-passed] of one-of lights with [name = "S6"] )
  ]


  ;; side 4 (Mode 4) R58
  if counter > side1 + side2 + side3 and counter <= side1 + side2 + side3 + side4 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] green
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] green

    ask lights with [color = green] [ set label side1 + side2 + side3 + side4 - counter ]
    ask lights with [name = "S1" or name = "S4"] [ set label cycle - counter ]
    ask lights with [name = "S2" or name = "S7"] [ set label cycle + side1 - counter ]
    ask lights with [name = "S3" or name = "S6"] [ set label cycle + side1 + side2 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side4 counter - side1 - side2 - side3
      ]
    ]

  ]

  if counter = side1 + side2 + side3 + side4 [
    output-print (word "side4-counter " side4 word " : S5 "   [cars-passed] of one-of lights with [name = "S5"] word "  S8 "  [cars-passed] of one-of lights with [name = "S8"] )
    output-print(word "Cycle Finished at " (ticks / 10) " in com4")
    set counter 0
    set cycle-end? true

  ]

  ask lights with[color = orange] [set label ""]
end

to combination-five  ;; 'com5': ['R15', 'R26', 'R34', 'R78']
  ;; side 1 (Mode 1) R15
  if counter <= side1 [
    change-color lights with [name = "S1"] green
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] green
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 - counter ]
    ask lights with [name = "S2" or name = "S6"] [ set label side1 - counter ]
    ask lights with [name = "S3" or name = "S4"] [ set label side1 + side2 - counter ]
    ask lights with [name = "S7" or name = "S8"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side1 counter
      ]
    ]

  ]

  ;;Output
  if counter = side1 and ticks mod 10 = 0 [
    output-print (word "side1-counter " side1 word " : S1 "   [cars-passed] of one-of lights with [name = "S1"] word "  S5 "  [cars-passed] of one-of lights with [name = "S5"])
  ]

  ;; side 2 (Mode 2) R26
  if counter > side1 and counter <= side1 + side2 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] green
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] green
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 + side2 - counter  ]
    ask lights with [name = "S1" or name = "S5"] [ set label cycle - counter ]
    ask lights with [name = "S3" or name = "S4"] [ set label side1 + side2 - counter ]
    ask lights with [name = "S7" or name = "S8"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side2 counter - side1
      ]
    ]

  ]

  ;;Output
  if counter = side1 + side2 and ticks mod 10 = 0 [
     output-print (word "side2-counter " side2 word " : S2 "   [cars-passed] of one-of lights with [name = "S2"] word "  S6 "  [cars-passed] of one-of lights with [name = "S6"] )
  ]

 ;; side 3 (Mode 3) R34
 if counter > side1 + side2 and counter <= side1 + side2 + side3 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] green
    change-color lights with [name = "S4"] green
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 + side2 + side3 - counter ]
    ask lights with [name = "S1" or name = "S5"] [ set label cycle - counter ]
    ask lights with [name = "S2" or name = "S6"] [ set label cycle + side1 - counter ]
    ask lights with [name = "S7" or name = "S8"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side3 counter - side1 - side2
      ]
    ]

  ]

  ;;Output
  if counter = side1 + side2 + side3 and ticks mod 10 = 0 [
     output-print (word "side3-counter " side3 word " : S3 "   [cars-passed] of one-of lights with [name = "S3"] word "  S4 "  [cars-passed] of one-of lights with [name = "S4"] )
  ]


  ;; side 4 (Mode 4) R78
  if counter > side1 + side2 + side3 and counter <= side1 + side2 + side3 + side4 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] green
    change-color lights with [name = "S8"] green

    ask lights with [color = green] [ set label side1 + side2 + side3 + side4 - counter ]
    ask lights with [name = "S1" or name = "S5"] [ set label cycle - counter ]
    ask lights with [name = "S2" or name = "S6"] [ set label cycle + side1 - counter ]
    ask lights with [name = "S3" or name = "S4"] [ set label cycle + side1 + side2 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side4 counter - side1 - side2 - side3
      ]
    ]

  ]

  if counter = side1 + side2 + side3 + side4 [
    output-print (word "side4-counter " side4 word " : S7 "   [cars-passed] of one-of lights with [name = "S5"] word "  S8 "  [cars-passed] of one-of lights with [name = "S8"] )
    output-print(word "Cycle Finished at " (ticks / 10) " in com5")
    set counter 0
    set cycle-end? true

  ]

  ask lights with[color = orange] [set label ""]
end

to combination-six  ;; 'com6': ['R15', 'R26', 'R37', 'R48']
  ;; side 1 (Mode 1) R15
  if counter <= side1 [
    change-color lights with [name = "S1"] green
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] green
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 - counter ]
    ask lights with [name = "S2" or name = "S6"] [ set label side1 - counter ]
    ask lights with [name = "S3" or name = "S7"] [ set label side1 + side2 - counter ]
    ask lights with [name = "S4" or name = "S8"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side1 counter
      ]
    ]

  ]

  ;;Output
  if counter = side1 and ticks mod 10 = 0 [
    output-print (word "side1-counter " side1 word " : S1 "   [cars-passed] of one-of lights with [name = "S1"] word "  S5 "  [cars-passed] of one-of lights with [name = "S5"])
  ]

  ;; side 2 (Mode 2) R26
  if counter > side1 and counter <= side1 + side2 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] green
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] green
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 + side2 - counter  ]
    ask lights with [name = "S1" or name = "S5"] [ set label cycle - counter ]
    ask lights with [name = "S3" or name = "S7"] [ set label side1 + side2 - counter ]
    ask lights with [name = "S4" or name = "S8"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side2 counter - side1
      ]
    ]

  ]

  ;;Output
  if counter = side1 + side2 and ticks mod 10 = 0 [
     output-print (word "side2-counter " side2 word " : S2 "   [cars-passed] of one-of lights with [name = "S2"] word "  S6 "  [cars-passed] of one-of lights with [name = "S6"] )
  ]

 ;; side 3 (Mode 3) R37
 if counter > side1 + side2 and counter <= side1 + side2 + side3 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] green
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] green
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 + side2 + side3 - counter ]
    ask lights with [name = "S1" or name = "S5"] [ set label cycle - counter ]
    ask lights with [name = "S2" or name = "S6"] [ set label cycle + side1 - counter ]
    ask lights with [name = "S4" or name = "S8"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side3 counter - side1 - side2
      ]
    ]

  ]

  ;;Output
  if counter = side1 + side2 + side3 and ticks mod 10 = 0 [
     output-print (word "side3-counter " side3 word " : S3 "   [cars-passed] of one-of lights with [name = "S3"] word "  S7 "  [cars-passed] of one-of lights with [name = "S7"] )
  ]


  ;; side 4 (Mode 4) R48
  if counter > side1 + side2 + side3 and counter <= side1 + side2 + side3 + side4 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] green
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] green

    ask lights with [color = green] [ set label side1 + side2 + side3 + side4 - counter ]
    ask lights with [name = "S1" or name = "S5"] [ set label cycle - counter ]
    ask lights with [name = "S2" or name = "S6"] [ set label cycle + side1 - counter ]
    ask lights with [name = "S3" or name = "S7"] [ set label cycle + side1 + side2 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side4 counter - side1 - side2 - side3
      ]
    ]

  ]

  if counter = side1 + side2 + side3 + side4 [
    output-print (word "side4-counter " side4 word " : S4 "   [cars-passed] of one-of lights with [name = "S4"] word "  S8 "  [cars-passed] of one-of lights with [name = "S8"] )
    output-print(word "Cycle Finished at " (ticks / 10) " in com6")
    set counter 0
    set cycle-end? true

  ]

  ask lights with[color = orange] [set label ""]
end

to combination-seven  ;; 'com6': ['R15', 'R27', 'R36', 'R48']
  ;; side 1 (Mode 1) R15
  if counter <= side1 [
    change-color lights with [name = "S1"] green
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] green
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 - counter ]
    ask lights with [name = "S2" or name = "S7"] [ set label side1 - counter ]
    ask lights with [name = "S3" or name = "S6"] [ set label side1 + side2 - counter ]
    ask lights with [name = "S4" or name = "S8"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side1 counter
      ]
    ]

  ]

  ;;Output
  if counter = side1 and ticks mod 10 = 0 [
    output-print (word "side1-counter " side1 word " : S1 "   [cars-passed] of one-of lights with [name = "S1"] word "  S5 "  [cars-passed] of one-of lights with [name = "S5"])
  ]

  ;; side 2 (Mode 2) R27
  if counter > side1 and counter <= side1 + side2 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] green
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] green
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 + side2 - counter  ]
    ask lights with [name = "S1" or name = "S5"] [ set label cycle - counter ]
    ask lights with [name = "S3" or name = "S6"] [ set label side1 + side2 - counter ]
    ask lights with [name = "S4" or name = "S8"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side2 counter - side1
      ]
    ]

  ]

  ;;Output
  if counter = side1 + side2 and ticks mod 10 = 0 [
     output-print (word "side2-counter " side2 word " : S2 "   [cars-passed] of one-of lights with [name = "S2"] word "  S7 "  [cars-passed] of one-of lights with [name = "S7"] )
  ]

 ;; side 3 (Mode 3) R36
 if counter > side1 + side2 and counter <= side1 + side2 + side3 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] green
    change-color lights with [name = "S4"] red
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] green
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] red

    ask lights with [color = green] [ set label side1 + side2 + side3 - counter ]
    ask lights with [name = "S1" or name = "S5"] [ set label cycle - counter ]
    ask lights with [name = "S2" or name = "S7"] [ set label cycle + side1 - counter ]
    ask lights with [name = "S4" or name = "S8"] [ set label side1 + side2 + side3 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side3 counter - side1 - side2
      ]
    ]

  ]

  ;;Output
  if counter = side1 + side2 + side3 and ticks mod 10 = 0 [
     output-print (word "side3-counter " side3 word " : S3 "   [cars-passed] of one-of lights with [name = "S3"] word "  S6 "  [cars-passed] of one-of lights with [name = "S6"] )
  ]


  ;; side 4 (Mode 4) R48
  if counter > side1 + side2 + side3 and counter <= side1 + side2 + side3 + side4 [
    change-color lights with [name = "S1"] red
    change-color lights with [name = "S2"] red
    change-color lights with [name = "S3"] red
    change-color lights with [name = "S4"] green
    change-color lights with [name = "S5"] red
    change-color lights with [name = "S6"] red
    change-color lights with [name = "S7"] red
    change-color lights with [name = "S8"] green

    ask lights with [color = green] [ set label side1 + side2 + side3 + side4 - counter ]
    ask lights with [name = "S1" or name = "S5"] [ set label cycle - counter ]
    ask lights with [name = "S2" or name = "S7"] [ set label cycle + side1 - counter ]
    ask lights with [name = "S3" or name = "S6"] [ set label cycle + side1 + side2 - counter ]

    if ticks mod (min-check * 10) = 0 [ ;; 3 sec checking
    let check lights with [color = green and density-num < min-density]
    if check != Nobody [
        set side4 counter - side1 - side2 - side3
      ]
    ]

  ]

  if counter = side1 + side2 + side3 + side4 [
    output-print (word "side4-counter " side4 word " : S4 "   [cars-passed] of one-of lights with [name = "S4"] word "  S8 "  [cars-passed] of one-of lights with [name = "S8"] )
    output-print(word "Cycle Finished at " (ticks / 10) " in com7")
    set counter 0
    set cycle-end? true

  ]

  ask lights with[color = orange] [set label ""]
end

to change-color [light-set after-color]
  ask light-set [
    set color after-color
    ]
end
@#$#@#$#@
GRAPHICS-WINDOW
197
16
1425
765
-1
-1
20.0
1
10
1
1
1
0
1
1
1
-30
30
-18
18
0
0
1
ticks
30.0

BUTTON
12
19
75
52
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
498
680
670
713
lane-one-population
lane-one-population
0
40
10.0
1
1
NIL
HORIZONTAL

SLIDER
1239
533
1411
566
lane-three-population
lane-three-population
0
60
12.0
1
1
NIL
HORIZONTAL

SLIDER
1239
573
1411
606
lane-four-population
lane-four-population
0
60
12.0
1
1
NIL
HORIZONTAL

SLIDER
498
718
670
751
lane-two-population
lane-two-population
0
40
10.0
1
1
NIL
HORIZONTAL

SLIDER
952
26
1124
59
lane-five-population
lane-five-population
0
40
11.0
1
1
NIL
HORIZONTAL

SLIDER
952
65
1124
98
lane-six-population
lane-six-population
0
40
11.0
1
1
NIL
HORIZONTAL

SLIDER
224
180
397
213
lane-seven-population
lane-seven-population
0
60
12.0
1
1
NIL
HORIZONTAL

SLIDER
225
218
397
251
lane-eight-population
lane-eight-population
0
60
11.0
1
1
NIL
HORIZONTAL

BUTTON
14
144
77
177
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
1514
46
1607
91
waiting overall
count cars with [ speed = 0 ]
0
1
11

PLOT
1437
98
1887
356
Waiting
time
waiting cars
0.0
100.0
0.0
100.0
true
true
"" ""
PENS
"waiting" 1.0 0 -2139308 true "" "plot count cars with [ speed = 0 ]"
"moving" 1.0 0 -13840069 true "" "plot count cars with [ speed != 0 ]"

BUTTON
82
144
157
177
go once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
15
190
133
223
wrap-world
wrap-world
0
1
-1000

SWITCH
17
290
120
323
peak
peak
0
1
-1000

INPUTBOX
628
523
678
583
side1
10.0
1
0
Number

MONITOR
1439
46
1504
91
total cars
count cars
17
1
11

MONITOR
1614
46
1724
91
traffic dentisy %
round ((count cars with [speed = 0] / count cars) * 100)
17
1
11

SWITCH
12
66
139
99
visible-speed
visible-speed
1
1
-1000

SWITCH
16
334
183
367
deadlock-detection
deadlock-detection
1
1
-1000

TEXTBOX
539
525
623
609
for each side -\n\n\nthen the \ntotal cycle time \nis = 4 * go-time
11
0.0
1

OUTPUT
1434
363
1881
647
11

TEXTBOX
16
105
166
123
10 tick = 1 second
11
0.0
1

INPUTBOX
226
25
288
85
cycle
33.0
1
0
Number

TEXTBOX
15
231
191
259
then the vehicles will vanished\nat the road end
11
0.0
1

INPUTBOX
945
525
1001
585
side2
10.0
1
0
Number

INPUTBOX
945
196
995
256
side3
10.0
1
0
Number

INPUTBOX
625
198
675
258
side4
10.0
1
0
Number

CHOOSER
295
26
452
71
routes-combinations
routes-combinations
"com1" "com2" "com3" "com4" "com5" "com6" "com7"
3

INPUTBOX
459
26
556
86
min-density
1.2
1
0
Number

MONITOR
1785
652
1881
733
NIL
counter
17
1
20

INPUTBOX
565
27
634
87
min-check
5.0
1
0
Number

BUTTON
201
566
286
599
NIL
go-cycle\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
201
524
272
563
NIL
set-sides\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
# 4-Way Junction Traffic Simulation (for Sri Lanka) using NetLogo

## WHAT IS IT?

The **4Way Junction Traffic Simulation** is a NetLogo model designed to simulate traffic flow at a four-way intersection. The model aims to represent the dynamics of vehicle movement through an intersection controlled by traffic lights, exploring how various traffic light timings and vehicle behaviors impact overall traffic efficiency and congestion. It is specifically adapted to reflect Sri Lankan road rules and traffic patterns.

## HOW IT WORKS

The model simulates vehicle movement and traffic light control at a four-way intersection. Key elements include:

- **Traffic Lights**: Controlled by dynamic timing adjustments to manage traffic flow.
- **Vehicles**: Move through the intersection according to traffic rules and light signals.
- **Intersection Management**: The model tracks traffic density, vehicle waiting times, and calculates traffic density.
- **Deadlock Detection**: Identifies when all vehicles are stopped or blocked, indicating a deadlock.

The agents (vehicles and traffic lights) use the following rules to create the overall behavior:

- Vehicles move forward based on their current heading and speed.
- Traffic lights change color based on preset timings and traffic conditions.
- Vehicles respond to traffic light changes and other vehicles at the intersection.
- The simulation detects and handles deadlocks by pausing and providing user notifications.

## HOW TO USE IT

To use the model:

1. **Interface Controls**: 
   - **Sliders**: Adjust parameters such as traffic light cycle times, vehicle population, and speed.
   - **Buttons**: Start and stop the simulation.
   - **Monitors**: Display real-time metrics such as total cars, waiting cars, and traffic density.
   - **Input Fields**: Enter preset values for traffic timers, including peak and off-peak times.

2. **Running the Simulation**:
   - Click the **"Setup"** button to initialize the model.
   - Use the **"Go"** button to start the simulation.
   - Adjust sliders and observe how changes affect traffic flow.

## THINGS TO NOTICE

- **Traffic Light Changes**: Watch how different traffic light timings impact vehicle movement and intersection congestion.
- **Deadlock Situations**: Observe scenarios where vehicles become blocked and how the model detects these situations.
- **Vehicle Behavior**: Notice how vehicles respond to traffic lights and other vehicles at the intersection.
- **Performance Impact**: Pay attention to how different speed settings affect the simulation's performance and realism.

## THINGS TO TRY

- **Adjust Traffic Light Timings**: Change the cycle times of traffic lights and observe how it affects traffic flow and congestion.
- **Experiment with Vehicle Density**: Populate roads with different numbers of vehicles and analyze the impact on traffic efficiency.
- **Change Peak and Off-Peak Times**: Modify peak and off-peak timings to see how traffic flow adjusts with varying traffic light schedules.
- **Modify Traffic Cycles**: Adjust the traffic light cycle times and observe the impact on vehicle movement and intersection management.
- **Simulate Different Traffic Scenarios**: Use the model to test various traffic management strategies and observe their effects.

## EXTENDING THE MODEL

To enhance the model further:

- **Add Overtaking Behavior**: Implement vehicle overtaking capabilities to reflect more realistic driving behaviors.
- **Incorporate Pedestrian Crossings**: Include pedestrian traffic and crossing signals to simulate a more comprehensive traffic environment.
- **Expand to Multiple Intersections**: Develop the model to cover a network of intersections for a more complex traffic simulation.
- **Integrate Real-Time Data**: Use real-time traffic data to update the simulation dynamically and improve accuracy.

## NETLOGO FEATURES

The model leverages several interesting NetLogo features:

- **Agent-Based Modeling**: Simulates individual vehicles and traffic lights as agents with specific behaviors.
- **Custom Sliders and Inputs**: Allows dynamic adjustment of parameters such as traffic light timings and vehicle counts.
- **Data Visualization**: Utilizes monitors and plots to visualize traffic metrics and performance.

## RELATED MODELS

- **TrafficBasic** by [Uri Wilensky](https://ccl.northwestern.edu/netlogo/models/TrafficBasic): A foundational model for basic traffic flow.
- **Traffic Grid** by [Uri Wilensky](https://ccl.northwestern.edu/netlogo/models/TrafficGrid): Extends basic traffic simulation to a grid layout.
- **Traffic Intersection** by [Uri Wilensky](https://ccl.northwestern.edu/netlogo/models/TrafficIntersection): Focuses on intersection management.
- **Traffic 2 Lanes** by [Uri Wilensky](https://ccl.northwestern.edu/netlogo/models/Traffic2Lanes): Explores multi-lane traffic dynamics.
- **Traffic Dynamics** by [Francesca De Min](https://ccl.northwestern.edu/netlogo/models/TrafficDynamics) and [Aurora Patetta](https://ccl.northwestern.edu/netlogo/models/TrafficDynamics): Examines complex traffic behaviors.
- **Traffic with Lane Changing** by [Carl Edwards](https://ccl.northwestern.edu/netlogo/models/TrafficWithLaneChanging): Simulates lane changing behaviors.
- **Randi Wakkubura** and **Dr. Budditha Hettige**: Provided context on local traffic management strategies.

## CREDITS AND REFERENCES

- **NetLogo Model Library**: Access and explore related models at [NetLogo Models Library](https://ccl.northwestern.edu/netlogo/models).
- **Uri Wilensky**: Developer of foundational traffic models.
- **Francesca De Min and Aurora Patetta**: Contributors to traffic dynamics research.
- **Carl Edwards**: Creator of lane changing traffic model.
- **Randi Wakkubura and Dr. Budditha Hettige**: Provided insights into local traffic management.

## COPYRIGHT NOTICE

© 2024 [Srimal Fernando](https://srimal.me), [NSBM Green University](https://nsbm.ac.lk), Sri Lanka. All rights reserved.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

car top
true
0
Polygon -7500403 true true 151 8 119 10 98 25 86 48 82 225 90 270 105 289 150 294 195 291 210 270 219 225 214 47 201 24 181 11
Polygon -16777216 true false 210 195 195 210 195 135 210 105
Polygon -16777216 true false 105 255 120 270 180 270 195 255 195 225 105 225
Polygon -16777216 true false 90 195 105 210 105 135 90 105
Polygon -1 true false 205 29 180 30 181 11
Line -7500403 false 210 165 195 165
Line -7500403 false 90 165 105 165
Polygon -16777216 true false 121 135 180 134 204 97 182 89 153 85 120 89 98 97
Line -16777216 false 210 90 195 30
Line -16777216 false 90 90 105 30
Polygon -1 true false 95 29 120 30 119 11

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fire
false
0
Polygon -7500403 true true 151 286 134 282 103 282 59 248 40 210 32 157 37 108 68 146 71 109 83 72 111 27 127 55 148 11 167 41 180 112 195 57 217 91 226 126 227 203 256 156 256 201 238 263 213 278 183 281
Polygon -955883 true false 126 284 91 251 85 212 91 168 103 132 118 153 125 181 135 141 151 96 185 161 195 203 193 253 164 286
Polygon -2674135 true false 155 284 172 268 172 243 162 224 148 201 130 233 131 260 135 282

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

light-left
true
0
Rectangle -16777216 true false 15 15 285 285
Rectangle -7500403 true true 30 30 270 270
Polygon -1 true false 120 45 45 120 120 195 120 150 150 150 150 240 210 240 210 90 120 90

light-right
true
0
Rectangle -16777216 true false 15 15 285 285
Rectangle -7500403 true true 30 30 270 270
Polygon -1 true false 180 45 255 120 180 195 180 150 150 150 150 240 90 240 90 90 180 90

light-straight
true
0
Rectangle -16777216 true false 15 15 285 285
Rectangle -7500403 true true 30 30 270 270
Polygon -1 true false 75 135 150 60 225 135 180 135 180 240 120 240 120 135 75 135 75 135

lights
false
0
Rectangle -16777216 true false 15 15 285 285
Rectangle -7500403 true true 30 30 270 270

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
