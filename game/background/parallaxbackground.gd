
extends ParallaxBackground

const MAX_SPEED = 30
const MIN_SPEED = 10
var clouds = null
var cloudSpeeds = {}
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	clouds = get_node("Clouds").get_children()
	for c in clouds:
		cloudSpeeds[c] = _randomSpeed()
	pass

func _randomSpeed():
	var speed = rand_range(MIN_SPEED,MAX_SPEED)
	return Vector2(speed,0)

func _process(delta):
	for c in clouds:
		var pos = c.get_pos() + cloudSpeeds[c] * delta
		if pos.x > 1270 + c.get_texture().get_width()/2:
			pos.x = -150
			cloudSpeeds[c] = _randomSpeed()
		c.set_pos(pos)
	



