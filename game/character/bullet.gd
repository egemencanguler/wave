
extends RigidBody2D

const C = preload("res://constants.gd")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("ExplotionTimer").start()
	pass


func explode():
	get_tree().call_group(0,C.GROUP_EXPLOTION,"_onExplotion",get_global_pos())





func _on_ExplotionTimer_timeout():
	explode()
	queue_free()
	pass # replace with function body
