extends Sprite

onready var player = get_node("../")
onready var item = $Item
var rot: float

func _process(delta):
	#idk why this works
	if player.controller:
		rotation = atan2((player.position-get_global_mouse_position()).x, -(player.position-get_global_mouse_position()).y)+PI/2
		item.rotation = -atan2((player.position-get_global_mouse_position()).x, -(player.position-get_global_mouse_position()).y)-PI/2
	else:
		rotation = player.transrot
		item.rotation = -player.transrot
	
	if player.controller:
		rot = atan2((player.position-get_global_mouse_position()).x, -(player.position-get_global_mouse_position()).y)/(PI/180)
	else:
		rot = (player.transrot-PI/2)/(PI/180)
	
	var angles = [-90+12.5 > rot and rot >= -90-12.5,
				-135+12.5 > rot and rot >= -135-12.5,
				-180+12.5 > rot or 180-12.5 < rot,
				135+12.5 > rot and rot >= 135-12.5,
				90+12.5 > rot and rot >= 90-12.5,
				45+12.5 > rot and rot >= 45-12.5,
				0+12.5 > rot and rot >= 0-12.5,
				-45+12.5 > rot and rot >= -45-12.5]
	
	var counter = 0
	for angle in angles:
		if angle:
			item.frame = counter
		counter += 1
	
	if (get_global_mouse_position()-player.position).y < 0:
		item.z_index = -1
	else:
		item.z_index = 1
		
	if (get_global_mouse_position()-player.position).y < 0:
		item.z_index = -1
	else:
		item.z_index = 1
