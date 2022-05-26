extends Sprite

onready var player = get_node("../") 
func _ready():
	pass



func _process(delta):
	if player.item_in_hand == "Flashlight":
		pass
#		print("hi")
#		texture.load_path = "res://.import/flashlight.png-728e39a7a1256b753872a39b8180ea3e.stex"
#		texture.resource_path = "res://art/flashlight.png"
