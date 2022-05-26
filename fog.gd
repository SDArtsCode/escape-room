extends AnimatedSprite

const DEFAULT_X = 406.0
const DEFAULT_Y = 273.707
const WIND_SPEED = 10
const GOAL_MIN = 100
const RANGE = 1000

var targ = Vector2(DEFAULT_X, DEFAULT_Y)
var goal = Vector2(DEFAULT_X, DEFAULT_Y)

func _process(delta):
#	while position.distance_to(goal) > GOAL_MIN:
#		goal = Vector2(randf(-RANGE, RANGE)+DEFAULT_X, randf(-RANGE, RANGE)+DEFAULT_Y)
	pass
#	position += Vector2(xtarg,ytarg).normalized()*WIND_SPEED*delta
