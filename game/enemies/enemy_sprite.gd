
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func setArmRotation(rotd):
	get_node("Arm").set_rotd(rotd)

func shootAnim():
	if get_node("AnimationPlayer").is_playing():
		get_node("AnimationPlayer").stop()
	get_node("AnimationPlayer").play("shoot")

func setBrainMode(on):
	if on:
		for c in get_children():
			if c.has_method("set_modulate"):
				c.set_modulate(Color(1,0,0,1))
	else:
		for c in get_children():
			if c.has_method("set_modulate"):
				c.set_modulate(Color(1,1,1,1))
	print("Brain Mode: ", on)
