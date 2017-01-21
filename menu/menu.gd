
extends Node2D


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass




func _on_PlayButton_pressed():
	get_tree().change_scene("res://game/level1.tscn")
	pass # replace with function body
