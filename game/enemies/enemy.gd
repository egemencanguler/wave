
extends RigidBody2D

const C = preload("res://constants.gd")
const Bullet = preload("res://game/character/gun/bullet.gd")
const EnemyBullet = preload("res://game/enemies/enemy_bullet.tscn")
const Box = preload("res://game/obstacles/box.gd")
const Character = preload("res://game/character/character.gd")
const SPEED = 150


const BULLET_SPEED = 800
export(bool) var shoot = false
export(float) var shootInterval = 1
export(float) var shootAngle = 0

signal controllableChanged(con)
signal mouseEnter(enter)
var controllable = false

func _ready():
#	add_to_group(C.GROUP_EXPLOTION)
	get_node("Sprite").setArmRotation(shootAngle)
	if shoot:
		get_node("ShootTimer").set_wait_time(shootInterval)
		get_node("ShootTimer").start()
	add_to_group(C.GROUP_ENEMY)
	set_fixed_process(true)
	set_process_unhandled_input(true)
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
		if body.dangerous:
			set_process_unhandled_input(false)
			emit_signal("controllableChanged",false)
			emit_signal("mouseEnter",false)
			get_node("SamplePlayer2D").play("death")
			var timer = Timer.new()
			hide()
			add_child(timer)
			timer.connect("timeout", self, "queue_free")
			timer.set_wait_time(0.5)
			timer.start()
	elif body extends Character:
		body.kill()

func connectPlayer(player):
	connect("controllableChanged",player,"_onControllableChanged")
	connect("mouseEnter",player,"_onEnemyMouseEnter")

func _on_Enemy_input_event( viewport, event, shape_idx ):
	print("Enemy Input")

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
		get_node("CollisionShape2D").set_scale(Vector2(-1,1))
		get_node("Sprite").walkAnim(true)
	elif state == STATE_MOVING_RIGHT:
		get_node("Sprite").set_scale(Vector2(1,1))
		get_node("CollisionShape2D").set_scale(Vector2(1,1))
		get_node("Sprite").walkAnim(true)
	elif state == STATE_NOT_MOVING:
		print("Not moving")
		get_node("Sprite").walkAnim(false)


func shoot():
	get_node("Sprite").shootAnim()
	get_node("SamplePlayer2D").play("fire")
	var bullet = EnemyBullet.instance()
	get_tree().get_current_scene().add_child(bullet)
	var dir = Vector2(get_node("Sprite").get_scale().x,0)
	dir = dir.rotated(sign(get_node("Sprite").get_scale().x) * (shootAngle / 360) * 2 * PI)
	var pos = get_global_pos() + dir * 140
	pos.y -= 10
	bullet.set_global_pos(pos)
	bullet.set_linear_velocity(dir * BULLET_SPEED)


func _on_ShootTimer_timeout():
	shoot()
	pass # replace with function body

var mouseEnterred = false
func _unhandled_input(event):
	if get_global_mouse_pos().distance_to(get_global_pos()) < 100:
		emit_signal("mouseEnter",true)
		mouseEnterred = true
	elif mouseEnterred:
		emit_signal("mouseEnter",false)
		mouseEnterred = false
	if mouseEnterred and event.is_action_pressed("click_right"):
		if !controllable:
			controllable = true
			get_node("Sprite").setBrainMode(true)
			emit_signal("controllableChanged",true)
			return
	if controllable and event.is_action_pressed("click_right"):
		controllable = false
		get_node("Sprite").setBrainMode(false)
		emit_signal("controllableChanged",false)
