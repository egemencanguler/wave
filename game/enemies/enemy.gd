
extends RigidBody2D

const C = preload("res://constants.gd")
const Bullet = preload("res://game/character/gun/bullet.gd")
const Box = preload("res://game/obstacles/box.gd")
const SPEED = 300

signal controllableChanged(con)
var controllable = false

func _ready():
#	add_to_group(C.GROUP_EXPLOTION)
	add_to_group(C.GROUP_ENEMY)
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if !controllable:
		return
	var vel = get_linear_velocity()
	if Input.is_action_pressed("ui_right"):
		vel.x = SPEED
		changeAnimationState(STATE_MOVING_RIGHT)
	elif Input.is_action_pressed("ui_left"):
		vel.x = -SPEED
		changeAnimationState(STATE_MOVING_LEFT)
	else:
		changeAnimationState(STATE_NOT_MOVING)
		vel.x = 0
	set_linear_velocity(vel)

func _onExplotion(explotionPos):
	return
	var o = _sendRay(get_global_pos(),explotionPos)
	print("On ex:",o)
	if o == null or o extends Bullet:
		var dis = get_global_pos() - explotionPos
		var impulse = 100 #max(1000 - dis.length(), 100)
		apply_impulse(Vector2(0,0), dis.normalized() * impulse)
		print("Explotion: ", dis)


func _sendRay(from, to):
	var space_state = get_world_2d().get_direct_space_state()
	var result = space_state.intersect_ray(from,to,[self])
	print(result,self)
	if (not result.empty()):
		return result.collider
	return null


func _on_Enemy_body_enter( body ):
	print("Enemy body enter")
	if body extends Box:
		queue_free()
		print("Enemy body enter", body)
	pass # replace with function body

func connectPlayer(player):
	connect("controllableChanged",player,"_onControllableChanged")

func _on_Enemy_input_event( viewport, event, shape_idx ):
	print("Enemy Input")
	if !controllable and event.is_action_pressed("click"):
		controllable = true
		get_node("Sprite").set_modulate(Color(1,0,0,1))
		emit_signal("controllableChanged",true)
	elif controllable and event.is_action_pressed("click"):
		controllable = false
		get_node("Sprite").set_modulate(Color(1,1,1,1))
		emit_signal("controllableChanged",false)
	pass # replace with function body

const STATE_MOVING_RIGHT = 0
const STATE_MOVING_LEFT = 1
const STATE_NOT_MOVING = 2

var state = -1
func changeAnimationState(s):
	if state == s:
		return
	state = s
	if state == STATE_MOVING_LEFT:
		set_scale(Vector2(-1,1))
	elif state == STATE_MOVING_RIGHT:
		set_scale(Vector2(1,1))
	elif state == STATE_NOT_MOVING:
		print("Not moving")
