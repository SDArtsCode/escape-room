extends KinematicBody2D

const WALK_SPEED = 60
const WALK_SOUND_GAP = 0.5

var dir_x = 0
var dir_y = 0
var walk: bool = true


# Limp controls
const LIMP = 60
const ACCEL = 200.0
const ACCEL_MIN = 1.0
var top = WALK_SPEED + LIMP
export var bottom = WALK_SPEED - LIMP

var up: bool = false
# --------------

export var limping: bool = false;
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.4

onready var Item_respawn = preload("res://Item1.tscn")

onready var pickup = $pickup
onready var footsteps = [[$footsteps1, $footsteps2], [$footsteps3, $footsteps4], [$footsteps5, $footsteps6]]
onready var chr = $char
var speed = WALK_SPEED
var item_in_hand = ""
var item_in_backpack = ""
var flashlight_in_hand = false

var timer = 0.0
var sound = 0


var velocity = Vector2.ZERO

func _ready() -> void:
	chr.playing = true

func _process(delta):
	if dir_x != 0 or dir_y != 0:
		chr.animation = "walkleft"
		timer += delta
		if timer >= WALK_SOUND_GAP:
			print("ploop")
			timer = 0.0
			footsteps[sound][randi()%2].play()
			sound += 1
			if sound >= 3:
				sound = 0
	else:
		chr.animation = "idle"
		
		
	if up: 
		speed += ACCEL*delta*(top-speed)/speed + ACCEL_MIN
	if not up: 
		speed -= ACCEL*delta*(speed-bottom)/speed + ACCEL_MIN
	
	if not limping:
		speed = WALK_SPEED
		
	if speed >= top or speed <= bottom:
			up = not up
		
		

func get_input():
	dir_x = 0
	dir_y = 0
	if walk:
		if Input.is_action_pressed("ui_right"):
			dir_x += 1
			chr.scale.x = 2
		if Input.is_action_pressed("ui_left"):
			dir_x -= 1
			chr.scale.x = -2
		if Input.is_action_pressed("ui_up"):
			dir_y -= 1
		if Input.is_action_pressed("ui_down"):
			dir_y += 1
		
		move_and_slide(Vector2(dir_x*speed, dir_y*speed))
		
		
		
		
#		if dir_x != 0 and dir_y != 0:
#			dir_x = Vector2(dir_x, dir_y).normalized().x
#			dir_y = Vector2(dir_x, dir_y).normalized().y
#		if dir_x != 0:
#			velocity.x = lerp(velocity.x, dir_x * speed, acceleration)
#		else:
#			velocity.x = lerp(velocity.x, 0, friction)
#
#		if dir_y != 0:
#			velocity.y = lerp(velocity.y, dir_y * speed, acceleration)
#		else:
#			#$AnimatedSprite.play('idle')
#			velocity.y = lerp(velocity.y, 0, friction)
	
				


func item_pickup():
	
	
	if Input.is_action_just_pressed("interact"):
		
			for body in $Item_Detector.get_overlapping_areas():
				if body.is_in_group("ITEMS") and item_in_hand == "":
					print (str(body.item_id) + " is in hand")
					pickup.play()
					item_in_hand = body.item_id
					body.queue_free()
					
				elif body.is_in_group("ITEMS") and not(item_in_hand == ""):
					print(str(body.item_id) + " is in backpack")
					pickup.play()
					item_in_backpack = body.item_id
					body.queue_free()
					
					
func item_drop():
	if Input.is_action_just_pressed("Drop") and not(item_in_hand == "") and item_in_backpack == "":
					
			var player = get_node("Item_Detector")
			var respawn = Item_respawn.instance()
		
			respawn.add_to_group("ITEMS")
			respawn.item_id = item_in_hand
			get_parent().add_child(respawn)		
			respawn.global_position = self.global_position	
			respawn.direction = get_local_mouse_position().normalized()
		
			print(str(item_in_hand) + " is dropped")
		
			item_in_hand = ""
		
	elif Input.is_action_just_pressed("Drop") and not(item_in_hand == "") and not(item_in_backpack == ""):
			
		var player = get_node("Item_Detector")
		var respawn = Item_respawn.instance()
		
		respawn.add_to_group("ITEMS")
		respawn.item_id = item_in_hand
		get_parent().add_child(respawn)		
		respawn.global_position = self.global_position	
		respawn.direction = get_local_mouse_position().normalized()
		print(str(item_in_hand) + " is dropped")
		
		item_in_hand = item_in_backpack
		item_in_backpack = ""

		print(str(item_in_hand) + " is now in hand")
		
		
		
func item_switch():
	
	if Input.is_action_just_pressed("switch items") and not(item_in_hand == "") and not(item_in_backpack == ""):
		
		var switch_placeholder = item_in_backpack
		item_in_backpack = item_in_hand
		item_in_hand = switch_placeholder
		
		print(str(item_in_hand) + " is in hand")
		print(str(item_in_backpack) + " is in backpack")
		
func check_flashlight():
	
	if item_in_hand == "Flashlight":
		flashlight_in_hand = true
		
	else:
		flashlight_in_hand = false
		
func handle_flashlight():
	
	if flashlight_in_hand == true:
		$ItemPivot/Item.show()
		$ItemPivot/Flashlight.enabled = true
	
	elif flashlight_in_hand == false:
		$ItemPivot/Flashlight.enabled = false
		$ItemPivot/Item.hide()
		
		
		
		
func _physics_process(delta):
	get_input()
	item_drop()
	item_pickup()
	item_switch()
	check_flashlight()
	handle_flashlight()
	velocity = move_and_slide(velocity)
	
	
	
	
	



