
extends KinematicBody2D

const GRAVITY = 1200.0
const WALK_ACCELERATION = 800
const WALK_SLOW_ACCELERATION = 1000
const WALK_MAX_SPEED = 400
const MIN_SPEED = 30
const JUMP = 400

var velocity = Vector2()
var acceleration = Vector2()
const Enemy = preload("res://game/enemies/enemy.gd")
var controllable = true
var onAir = false

signal die()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	acceleration.y = GRAVITY
	velocity += delta * acceleration
	if abs(velocity.x) > WALK_MAX_SPEED:
		velocity.x = sign(velocity.x) * WALK_MAX_SPEED
	var motion = velocity * delta
	if Input.is_action_pressed("ui_left") and controllable:
		if velocity.x > 0:
			velocity.x = 0
		acceleration.x = -WALK_ACCELERATION
		changeAnimationState(STATE_MOVING_LEFT)
	elif Input.is_action_pressed("ui_right") and controllable:
		if velocity.x < 0:
			velocity.x = 0
		acceleration.x = WALK_ACCELERATION
		changeAnimationState(STATE_MOVING_RIGHT)
	else:
		if velocity.x > MIN_SPEED:
			acceleration.x = -WALK_SLOW_ACCELERATION
		elif velocity.x < -MIN_SPEED:
			acceleration.x = WALK_SLOW_ACCELERATION
		else:
			changeAnimationState(STATE_NOT_MOVING)
			velocity.x = 0
			acceleration.x = 0
	move(motion)
	if is_colliding():
		if get_collider() extends Enemy:
			kill()
		var n = get_collision_normal()
		if abs(n.angle()) > 2.5:
			onAir = false
		if Input.is_action_pressed("ui_up") and abs(n.angle()) > 2.5 and controllable:
			changeAnimationState(STATE_JUMPING)
			onAir = true
			velocity.y = -JUMP
		else:
			motion = n.slide(motion)
			velocity = n.slide(velocity)
			move(motion)
	if Input.is_action_pressed("click") and controllable:
		get_node("Gun").shoot()

func _isOnFloor():
	if is_colliding():
		var n = get_collision_normal()
		return true
	return false

func kill():
	emit_signal("die")
	queue_free()

func _onControllableChanged(con):
	controllable = !con

const STATE_MOVING_LEFT = 0
const STATE_MOVING_RIGHT= 1
const STATE_NOT_MOVING = 2
const STATE_JUMPING = 3
var state
func changeAnimationState(s):
	if state == s:
		return
	state = s
	if state == STATE_MOVING_LEFT:
		get_node("Sprite").set_scale(Vector2(-1,1))
	elif state == STATE_MOVING_RIGHT:
		get_node("Sprite").set_scale(Vector2(1,1))
	elif state == STATE_NOT_MOVING:
		print("Not Moving")
	elif state == STATE_JUMPING:
		print("Jumping")
	pass