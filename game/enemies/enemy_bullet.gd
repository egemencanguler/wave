
extends RigidBody2D


const Character = preload("res://game/character/character.gd")

func _ready():
	pass




func _on_EnemyBullet_body_enter( body ):
	if body extends Character:
		body.kill()
	pass # replace with function body
