
extends RigidBody2D


const C = preload("res://constants.gd")
const Bullet = preload("res://game/character/gun/bullet.gd")

func _ready():
	add_to_group(C.GROUP_EXPLOTION)
	pass

func _onExplotion(explotionPos):
	var o = _sendRay(get_global_pos(),explotionPos)
	if o == null or o extends Bullet:
		var dis = get_global_pos() - explotionPos
		var len = dis.length()
		if len < 300:
			var impulse = -300
			if dis.x > 0:
				impulse = 300
			set_linear_velocity(Vector2(impulse,0))
#			apply_impulse(Vector2(0,0), dis.normalized() * impulse)
			print("Explotion: ", dis)


func _sendRay(from, to):
	var space_state = get_world_2d().get_direct_space_state()
	var result = space_state.intersect_ray(from,to,[self])
	print(result,self)
	if (not result.empty()):
		return result.collider
	return null


