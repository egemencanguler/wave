
extends Node2D
var Ball = preload("res://minigame/ball.gd")


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass




func _on_Area2D_body_enter( body ):
	if body extends Ball:
		if body.enemy:
			print("Enemy")
		else:
			print("Allies")
	pass # replace with function body
