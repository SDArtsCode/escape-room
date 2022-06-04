extends KinematicBody2D

export var plr: int
const WALK_SPEED = 60
const WALK_SOUND_GAP = 0.5

var dir_x = 0
var dir_y = 0
var walk: bool = true
var walking = false


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

onready var global = get_node("../")
onready var item_pivot = $ItemPivot
onready var camera = $Camera2D
onready var pickup_sfx = $pickup
onready var footsteps = [[$footsteps1, $footsteps2], [$footsteps3, $footsteps4], [$footsteps5, $footsteps6]]
onready var chr = $char
var speed = WALK_SPEED
var item_in_hand = ""
var item_in_backpack = ""
var flashlight_in_hand = false

var controller = false

# useless vars
var timer = 0.0
var sound = 0

var velocity = Vector2.ZERO


#networing vars
const MAX_NETWORK_REACH = 500.0
var transrot = 0.0
var on: bool
var pickup: String = ""
var done = [false, false]
var dropped: bool = false
var net_timer = 0.0

func _ready() -> void:
	chr.playing = true
	controller = Networking.player_num == plr
	if controller:
		camera.current = true

#func sortdist(a, b):
#	if a.global_position.distance_to(position) < b.global_position.distance_to(position):
#		return true
#	return false



func _process(delta):
#	print(plr, ": ", pickup)
	if controller:
		transrot = item_pivot.rotation
		if done[1]:
			net_timer += delta
			if net_timer >= 0.5:
				done[1] = false
				net_timer = 0 
	if not controller and pickup != "" and not done[0]:
		done[0] = true
#		fix bug with this, enables nearest item 
#		for body in get_tree().get_nodes_in_group("ITEMS").sort_custom(self, "sortdist"):
		for body in get_tree().get_nodes_in_group("ITEMS"):
			if body.item_id == pickup and position.distance_to(body.global_position) <= MAX_NETWORK_REACH:
				body.queue_free()
				pickup_sfx.play()
				break
	elif not controller and done[0] and pickup == "":
		done[0] = false
	
#	if not controller and dropped and not done[1]:
#		done[1] = true
#		var respawn = Item_respawn.instance()
#		respawn.add_to_group("ITEMS")
#		respawn.item_id = item_in_hand
#		respawn.plr = plr
#		get_parent().add_child(respawn)
#
#	elif not controller and done[1] and not dropped:
#		done[1] = false
		
	for body in $Item_Detector.get_overlapping_areas():
		if body.name.begins_with("Item") and body.name != "Item_Detector":
			body.indicator.show()
			body.timer = 0.1
	if dir_x != 0 or dir_y != 0:
		chr.animation = "walkleft"
		timer += delta
		if timer >= WALK_SOUND_GAP:
			timer = 0.0
			footsteps[sound][randi()%2].play()
			sound += 1
			if sound >= 3:
				sound = 0
	else:
		pass
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
		pickup = ""
	if Input.is_action_just_released("interact"):
		for body in $Item_Detector.get_overlapping_areas():
			if body.is_in_group("ITEMS") and item_in_hand == "":
				print (str(body.item_id) + " is in hand")
				pickup_sfx.play()
				pickup = body.item_id
				item_in_hand = body.item_id
				body.queue_free()
				
			elif body.is_in_group("ITEMS") and not(item_in_hand == ""):
				print(str(body.item_id) + " is in backpack")
				pickup_sfx.play()
				pickup = body.item_id
				item_in_backpack = body.item_id
				body.queue_free()
					
					
func item_drop():
	if Input.is_action_just_pressed("Drop"):
		print("icyu")
	if Input.is_action_just_pressed("Drop") and not(item_in_hand == "") and item_in_backpack == "":
		var player = get_node("Item_Detector")
		var respawn = Item_respawn.instance()
		respawn.add_to_group("ITEMS")
		respawn.item_id = item_in_hand
		respawn.plr = plr
		get_parent().add_child(respawn)
		dropped = true
		respawn.global_position = self.global_position
		respawn.direction = get_local_mouse_position().normalized()
	
		print(str(item_in_hand) + " is dropped")
	
		item_in_hand = ""
		
	elif Input.is_action_just_pressed("Drop") and not(item_in_hand == "") and not(item_in_backpack == ""):
			
		var player = get_node("Item_Detector")
		var respawn = Item_respawn.instance()
		
		respawn.add_to_group("ITEMS")
		respawn.item_id = item_in_hand
		respawn.plr = plr
		get_parent().add_child(respawn)
		dropped = true
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
	if controller:
		get_input()
		item_drop()
		item_pickup()
		item_switch()
	check_flashlight()
	handle_flashlight()
	velocity = move_and_slide(velocity)
	
	
	
	
	



