
extends RigidBody2D


const Character = preload("res://game/character/character.gd")
const Bullet = preload("res://game/character/gun/bullet.gd")

func _ready():
	pass

func _on_EnemyBullet_body_enter( body ):
	if body extends Bullet:
		return
	queue_free()
	pass # replace with function body
