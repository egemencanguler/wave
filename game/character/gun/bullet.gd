
extends RigidBody2D

const C = preload("res://constants.gd")
const Character = preload("res://game/character/character.gd")
const BulletEffect = preload("res://game/character/gun/bullet_effect.tscn")

func _ready():
	add_collision_exception_with(get_tree().get_current_scene().get_node("Character"))
	pass

func explode():
	get_tree().call_group(0,C.GROUP_EXPLOTION,"_onExplotion",get_global_pos())
	var effect = BulletEffect.instance()
	get_tree().get_current_scene().add_child(effect)
	effect.set_global_pos(get_global_pos())

func _on_ExplotionTimer_timeout():
	explode()
	queue_free()
	pass # replace with function body


func _on_Bullet_body_enter( body ):
	if not body extends Character:
		get_node("ExplotionTimer").start()
		print("Bullet")
	pass # replace with function body
