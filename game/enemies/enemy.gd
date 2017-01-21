
extends RigidBody2D

const C = preload("res://constants.gd")
const Bullet = preload("res://game/character/gun/bullet.gd")
const EnemyBullet = preload("res://game/enemies/enemy_bullet.tscn")
const Box = preload("res://game/obstacles/box.gd")

const SPEED = 150

export(bool) var shoot = false
signal controllableChanged(con)
var controllable = false

func _ready():
#	add_to_group(C.GROUP_EXPLOTION)
	get_node("ShootTimer").start()
	add_to_group(C.GROUP_ENEMY)
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	var vel = get_linear_velocity()
	if !controllable:
		if get_parent() extends PathFollow2D:
			var uofset = get_parent().get_unit_offset()
			uofset = uofset - int(uofset)
			get_parent().set_offset(get_parent().get_offset() + (SPEED * delta))
			if uofset < 0.5:
				changeAnimationState(STATE_MOVING_RIGHT)
			else:
				changeAnimationState(STATE_MOVING_LEFT)
		return
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

func _on_Enemy_body_enter( body ):
	if body extends Box:
		queue_free()

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

const STATE_MOVING_RIGHT = 0
const STATE_MOVING_LEFT = 1
const STATE_NOT_MOVING = 2

var state = -1
func changeAnimationState(s):
	if state == s:
		return
	state = s
	if state == STATE_MOVING_LEFT:
		get_node("Sprite").set_scale(Vector2(-1,1))
	elif state == STATE_MOVING_RIGHT:
		get_node("Sprite").set_scale(Vector2(1,1))
	elif state == STATE_NOT_MOVING:
		print("Not moving")


const BULLET_SPEED = 300
func shoot():
	if !shoot:
		return
	var bullet = EnemyBullet.instance()
	get_tree().get_current_scene().add_child(bullet)
	var dir = Vector2(get_node("Sprite").get_scale().x,0)
	bullet.set_global_pos(get_global_pos() + dir * 100)
	bullet.set_linear_velocity(dir * BULLET_SPEED)


func _on_ShootTimer_timeout():
	shoot()
	pass # replace with function body
