extends Area2D

export var item_id = "default"
var drop_speed = 170.0*1.25
var direction = Vector2()
var plr: int = 0
var timer = 9999999999.0
onready var indicator = $Indicator
const DRAG = 184


func _ready() -> void:
	pass
#	if item_id == "Flashlight":
#		$Sprite.texture.resource_path = "res://art/flashlight.png"
	
	
#func _on_Item1_body_entered(body: Node) -> void:
#	if body.name == "Item_Detector":
#		$Indicator.show()
#
#func _on_Item1_body_exited(body: Node) -> void:
#	if body.name == "Item_Detector":
#		$Indicator.hide()


func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		indicator.hide()
	position += direction * drop_speed * delta
	if drop_speed > 0:
		drop_speed -= DRAG * delta
	
	elif drop_speed < 0:
		drop_speed = 0
