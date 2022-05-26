extends Sprite

onready var player = get_node("../")
onready var item = $Item

func _process(delta):
	#idk why this works
	rotation = atan2((player.position-get_global_mouse_position()).x, -(player.position-get_global_mouse_position()).y)+PI/2
	item.rotation = -atan2((player.position-get_global_mouse_position()).x, -(player.position-get_global_mouse_position()).y)-PI/2
	
	var rot = atan2((player.position-get_global_mouse_position()).x, -(player.position-get_global_mouse_position()).y)/(PI/180)
	var angles = [(-1 > rot and rot >= -135),
				(-135 > rot and rot >= -180) or (135 < rot and rot <= 180)
				]
	for angle in angles:
		if angle:
			pass
	
	if (get_global_mouse_position()-player.position).y < 0:
		item.z_index = -1
	else:
		item.z_index = 1
		
	if (get_global_mouse_position()-player.position).y < 0:
		item.z_index = -1
	else:
		item.z_index = 1
