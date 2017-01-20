
extends RigidBody2D

const C = preload("res://constants.gd")
const Bullet = preload("res://game/character/bullet.gd")

func _ready():
	add_to_group(C.GROUP_EXPLOTION)
	pass

func _onExplotion(explotionPos):
	var o = _sendRay(get_global_pos(),explotionPos)
	print("On ex:",o)
	if o == null or o extends Bullet:
		var dis = get_global_pos() - explotionPos
		var impulse = max(1000 - dis.length(), 100)
		apply_impulse(Vector2(0,0), dis.normalized() * impulse)
		print("Explotion: ", dis)


func _sendRay(from, to):
	var space_state = get_world_2d().get_direct_space_state()
	var result = space_state.intersect_ray(from,to,[self])
	print(result,self)
	if (not result.empty()):
		return result.collider
	return null
