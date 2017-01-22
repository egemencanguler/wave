
extends RigidBody2D


const C = preload("res://constants.gd")
const Bullet = preload("res://game/character/gun/bullet.gd")
const Character = preload("res://game/character/character.gd")
const U = preload("res://utilities/util.gd")

const TEX_SAFE = preload("res://game/obstacles/safe_box.png")
const TEX_DAN = preload("res://game/obstacles/dan_box.png")

export(bool) var dangerous = false

func _ready():
	if dangerous:
		get_node("Sprite").set_texture(TEX_DAN)
	else:
		get_node("Sprite").set_texture(TEX_SAFE)
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
			print("Explotion: ", dis)


func _sendRay(from, to):
	var space_state = get_world_2d().get_direct_space_state()
	var result = space_state.intersect_ray(from,to,[self])
	print(result,self)
	if (not result.empty()):
		return result.collider
	return null


func _on_Box_body_enter( body ):
	if body extends Character and dangerous:
		body.kill()
	pass # replace with function body
