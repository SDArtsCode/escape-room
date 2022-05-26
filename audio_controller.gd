extends Node2D


onready var airy_start = $airy_start
onready var airy_loop = $airy_loop
onready var light_start = $light_start
onready var light_loop = $light_loop
onready var cave_noises = [$cavesound1, $cavesound2, $cavesound3, $cavesound4, $cavesound5, $cavesound6]
var lights_on = false
var lights_first = true
var time: float
var next: int = 15
var counter: int = 0

func _ready():
	airy_start.play()

func _process(delta):
	time += delta
	if not airy_loop.playing and not airy_start.playing:
		airy_loop.play()
	if lights_on:
		if not light_loop.playing and not light_start.playing:
			
			if lights_first:
				light_start.play()
				lights_first = false
			else:
				light_loop.play()
	
	if time >= next:
		cave_noises[counter].play()
		counter += 1
		if counter >= 5:
			counter = 0
		next = rand_range(30, 50)
		time = 0.0
		
		
		
func _input(event):
	if event.is_action_pressed("debug"):
		lights_on = true
