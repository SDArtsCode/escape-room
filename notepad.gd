extends Node2D

var notepad: bool = true
var up: bool = false
onready var box = $TextEdit
onready var player_light = get_node("../../PlayerLight")
onready var player = get_node("../../")
var plrnrg = 0.0

func _ready():
	scale = Vector2.ZERO
	plrnrg = player_light.energy
	modulate = Color(1, 1, 1, 1)

func _input(event):
	if event.is_action_pressed("notepad") and notepad and not up:
		scale = Vector2.ONE
		box.readonly = false
		player_light.energy = 0
		player.walk = false
		up = true
	elif event.is_action_pressed("notepad") and notepad and up:
		scale = Vector2.ZERO
		box.readonly = true
		player_light.energy = plrnrg
		player.walk = true
		up = false
	
