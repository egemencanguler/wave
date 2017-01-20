
extends KinematicBody2D

const GRAVITY = 1200.0
const WALK_ACCELERATION = 800
const WALK_SLOW_ACCELERATION = 1000
const WALK_MAX_SPEED = 400
const MIN_SPEED = 30
const JUMP = 400

var velocity = Vector2()
var acceleration = Vector2()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	acceleration.y = GRAVITY
	velocity += delta * acceleration
	if abs(velocity.x) > WALK_MAX_SPEED:
		velocity.x = sign(velocity.x) * WALK_MAX_SPEED
	var motion = velocity * delta
	if Input.is_action_pressed("ui_left"):
		if velocity.x > 0:
			velocity.x = 0
		acceleration.x = -WALK_ACCELERATION
	elif Input.is_action_pressed("ui_right"):
		if velocity.x < 0:
			velocity.x = 0
		acceleration.x = WALK_ACCELERATION
	else:
		if velocity.x > MIN_SPEED:
			acceleration.x = -WALK_SLOW_ACCELERATION
		elif velocity.x < -MIN_SPEED:
			acceleration.x = WALK_SLOW_ACCELERATION
		else:
			velocity.x = 0
			acceleration.x = 0
	move(motion)
	if is_colliding():
		var n = get_collision_normal()
		if Input.is_action_pressed("ui_up") and abs(n.angle()) > 2.5:
			print(n.angle())
			velocity.y = -JUMP
		else:
			motion = n.slide(motion)
			velocity = n.slide(velocity)
			move(motion)
	if Input.is_action_pressed("click"):
		get_node("Gun").shoot()

func _isOnFloor():
	if is_colliding():
		var n = get_collision_normal()
		return true
	return false