
extends RigidBody2D

const C = preload("res://constants.gd")
const SCALE = 0.05

export(bool) var enemy = false

func _ready():
	add_to_group(C.GROUP_BALL)
	_updateTexture()
	pass


func _applyForce(sourcePos):
	if _sendRay(get_global_pos(),sourcePos):
		var dis = -sourcePos + get_global_pos()
		print(dis)
		apply_impulse(Vector2(0,0),dis * SCALE)

func _updateTexture():
	if enemy:
		get_node("Sprite").set_modulate(Color(0,0,0,1))
	else:
		get_node("Sprite").set_modulate(Color(1,1,1,1))

func _sendRay(from, to):
	var space_state = get_world_2d().get_direct_space_state()
	var result = space_state.intersect_ray(from,to)
	if (not result.empty()):
		# There is something between
		return false
	return true


