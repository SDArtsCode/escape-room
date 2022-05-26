extends Camera2D


var targ_x: float = 0.0
var targ_y: float = 0.0
var dist_target: float = 0.0
const CAMERA_DRAG = 100.0
const CAMERA_SCALE = 0.0
#100

# zoom controls
const ZOOM_AMMOUNT = 0.05
const ZOOM_MAX = 1.1
const ZOOM_MIN = 0.1
#0.7
# -------------

func _process(delta):
#	print("("+str(targ_x)+", "+str(targ_y)+")")
	if position.distance_to(Vector2(targ_x*CAMERA_SCALE, targ_y*CAMERA_SCALE)) < 1.0:
		position = Vector2(targ_x*CAMERA_SCALE, targ_y*CAMERA_SCALE)
	else:
		position += Vector2(targ_x*delta*CAMERA_SCALE*abs(position.x-targ_x*CAMERA_SCALE)/CAMERA_DRAG, targ_y*delta*CAMERA_SCALE*abs(position.y-targ_y*CAMERA_SCALE)/CAMERA_DRAG)
	
	if targ_x == 0.0:
		position.x += -position.x*delta*CAMERA_SCALE/CAMERA_DRAG
	if targ_y == 0.0:
		position.y += -position.y*delta*CAMERA_SCALE/CAMERA_DRAG

func _input(event):
	# camera with character movement
	if event.is_action_pressed("up"):
		targ_y = -1.0
	elif event.is_action_pressed("down"):
		targ_y = 1.0
	elif event.is_action_released("up") or event.is_action_released("down"):
		targ_y = 0.0
	

	elif event.is_action_pressed("left"):
		targ_x = -1.0
	elif event.is_action_pressed("right"):
		targ_x = 1.0
	elif event.is_action_released("left") or event.is_action_released("right"):
		targ_x = 0.0
	
	# zoom controls
	if event.is_action_pressed("zoom_in") and zoom.x > ZOOM_MIN:
		zoom -= Vector2(ZOOM_AMMOUNT, ZOOM_AMMOUNT)
		
	if event.is_action_pressed("zoom_out") and zoom.x < ZOOM_MAX:
		zoom += Vector2(ZOOM_AMMOUNT, ZOOM_AMMOUNT)
	
