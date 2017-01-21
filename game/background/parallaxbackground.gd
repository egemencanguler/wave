
extends ParallaxBackground

const MAX_SPEED = 30
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
	var speed = rand_range(-MAX_SPEED,MAX_SPEED)
	return Vector2(speed,0)

func _process(delta):
	for c in clouds:
		var pos = c.get_pos() + cloudSpeeds[c] * delta
		if pos.x < 0:
			pos.x = 0
			cloudSpeeds[c].x = abs(cloudSpeeds[c].x)
		elif pos.x > 1270:
			pos.x = 1270
			cloudSpeeds[c].x = -abs(cloudSpeeds[c].x)
		c.set_pos(pos)
	



