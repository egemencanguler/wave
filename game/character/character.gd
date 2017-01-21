
extends KinematicBody2D

const GRAVITY = 1200.0
const WALK_ACCELERATION = 1000
const WALK_SLOW_ACCELERATION = 1000
const WALK_MAX_SPEED = 300
const MIN_SPEED = 30
const JUMP = 500

var velocity = Vector2()
var acceleration = Vector2()

const Enemy = preload("res://game/enemies/enemy.gd")
const Box = preload("res://game/obstacles/box.gd")
const EnemyBullet = preload("res://game/enemies/enemy_bullet.gd")

var controllable = true
var onAir = false

signal die()

func _ready():
	set_fixed_process(true)
	set_process(true)

func _fixed_process(delta):
	var moveLeft = Input.is_action_pressed("ui_left")
	var moveRight = Input.is_action_pressed("ui_right")
	var lean = Input.is_action_pressed("ui_down")
	acceleration.y = GRAVITY
	velocity += delta * acceleration
	if abs(velocity.x) > WALK_MAX_SPEED:
		velocity.x = sign(velocity.x) * WALK_MAX_SPEED
	var motion = velocity * delta
	if moveLeft and controllable:
		if velocity.x > 0:
			velocity.x = 0
		acceleration.x = -WALK_ACCELERATION
		changeAnimationState(STATE_MOVING_LEFT)
	elif moveRight and controllable:
		if velocity.x < 0:
			velocity.x = 0
		acceleration.x = WALK_ACCELERATION
		changeAnimationState(STATE_MOVING_RIGHT)
	if lean and controllable:
		_lean()
	if !moveLeft and !moveRight:
		if velocity.x > MIN_SPEED:
			acceleration.x = -WALK_SLOW_ACCELERATION
		elif velocity.x < -MIN_SPEED:
			acceleration.x = WALK_SLOW_ACCELERATION
		else:
			if !lean:
				changeAnimationState(STATE_NOT_MOVING)
			velocity.x = 0
			acceleration.x = 0
	move(motion)
	if is_colliding():
		_handleCollision()
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

func kill():
	emit_signal("die")
	queue_free()

func _handleCollision():
	var object = get_collider()
	if object extends Enemy or object extends EnemyBullet:
		kill()
func _onControllableChanged(con):
	controllable = !con

const STATE_MOVING_LEFT = 0
const STATE_MOVING_RIGHT= 1
const STATE_NOT_MOVING = 2
const STATE_JUMPING = 3
const STATE_LEAN = 4
var state
func changeAnimationState(s):
	if state == s:
		return
	if state == STATE_LEAN and s == STATE_NOT_MOVING:
		_stand()
	state = s
	if state == STATE_MOVING_LEFT:
		var scale = get_node("AnimatedSprite").get_scale()
		scale.x = -abs(scale.x)
		get_node("AnimatedSprite").set_scale(scale)
	elif state == STATE_MOVING_RIGHT:
		var scale = get_node("AnimatedSprite").get_scale()
		scale.x = abs(scale.x)
		get_node("AnimatedSprite").set_scale(scale)
	elif state == STATE_NOT_MOVING:
		get_node("AnimationPlayer").stop()
		get_node("AnimatedSprite").set_frame(6)
		print("Not Moving")
	elif state == STATE_JUMPING:
		print("Jumping")
	elif state == STATE_LEAN:
		_lean()
	pass

func _lean():
#	get_node("Sprite").set_pos(Vector2(0,36))
#	get_node("Sprite").set_scale(Vector2(1,0.5))
#	changeAnimationState(STATE_LEAN)
	pass

func _stand():
	pass
#	get_node("Sprite").set_pos(Vector2(0,0))
#	get_node("Sprite").set_scale(Vector2(1,1))

func _process(delta):
	if state == STATE_MOVING_LEFT or state == STATE_MOVING_RIGHT:
		if !get_node("AnimationPlayer").is_playing():
			get_node("AnimationPlayer").play("walk")

func _onEnemyMouseEnter(enter):
	if enter:
		get_node("Gun").changeCursorBrain()
	else:
		get_node("Gun").changeCursorGun()
