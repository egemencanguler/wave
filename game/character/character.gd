
extends KinematicBody2D

const GRAVITY = 1200.0
const WALK_ACCELERATION = 1000
const WALK_SLOW_ACCELERATION = 1500
const WALK_MAX_SPEED = 350
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
	set_process_unhandled_input(true)



func _fixed_process(delta):
	_handleCollision()
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
	_handleCollision()
	if is_colliding():
		var n = get_collision_normal()
		var na = abs(n.angle())
		if na > 2:
			onAir = false
		if Input.is_action_pressed("ui_up") and na > 2 and controllable:
			changeAnimationState(STATE_JUMPING)
			onAir = true
			velocity.y = -JUMP
			print("Jump")
			get_node("SamplePlayer2D").set_random_pitch_scale(0)
			get_node("SamplePlayer2D").play("jump")
		else:
			motion = n.slide(motion)
			velocity = n.slide(velocity)
			move(motion)
			_handleCollision()
	if Input.is_action_pressed("click") and controllable:
		if !get_node("Gun").cooldown:
			get_node("SamplePlayer2D").set_random_pitch_scale(0.5)
			get_node("SamplePlayer2D").play("char_fire")
		get_node("Gun").shoot()

var killed = false
func kill():
	if killed:
		return
	killed = true
	emit_signal("die")
	print("Death")
#	queue_free()

func _handleCollision():
	if !is_colliding():
		return
	var object = get_collider()
	if object extends Enemy or object extends EnemyBullet or (object extends Box and object.dangerous):
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
#		get_node("AnimatedSprite").set_scale(scale)
	elif state == STATE_MOVING_RIGHT:
		var scale = get_node("AnimatedSprite").get_scale()
		scale.x = abs(scale.x)
#		get_node("AnimatedSprite").set_scale(scale)
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
	if state == STATE_MOVING_LEFT:
		if get_node("AnimatedSprite").get_scale().x < 0:
			_playWalk()
		else:
			_playWalkBack()
	elif state == STATE_MOVING_RIGHT:
		if get_node("AnimatedSprite").get_scale().x < 0:
			_playWalkBack()
		else:
			_playWalk()


func _playWalk():
#	get_node("AnimatedSprite").set_modulate(Color(1,1,1,1))
	if !get_node("AnimationPlayer").is_playing():
			get_node("AnimationPlayer").play("walk")

func _playWalkBack():
#	get_node("AnimatedSprite").set_modulate(Color(0,1,0,1))
	if !get_node("AnimationPlayer").is_playing():
			get_node("AnimationPlayer").play_backwards("walk")
func _onEnemyMouseEnter(enter):
	if enter:
		get_node("Gun").changeCursorBrain()
	else:
		get_node("Gun").changeCursorGun()

var walkBack = false
func _unhandled_input(event):
	var mpos = get_global_mouse_pos()
	var pos = get_global_pos()
	if pos.x < mpos.x :
		#Mouse on right
		var scale = get_node("AnimatedSprite").get_scale()
		scale.x = abs(scale.x)
		get_node("AnimatedSprite").set_scale(scale)
	else:
		var scale = get_node("AnimatedSprite").get_scale()
		scale.x = -abs(scale.x)
		get_node("AnimatedSprite").set_scale(scale)
	var angle = (mpos - pos).angle()
	
