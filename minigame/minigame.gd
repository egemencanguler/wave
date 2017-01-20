
extends Node2D

const C = preload("res://constants.gd")

var inputStarted = false
var inputPos = null

func _ready():
	set_process_unhandled_input(true)
	set_process(true)
	pass

func _unhandled_input(event):
	if event.is_action_pressed("click"):
		inputPos = get_global_mouse_pos()
		inputStarted = true
	elif event.is_action_released("click"):
		inputPos = null
		inputStarted = false
	pass

func _process(delta):
	if inputStarted:
		_applyForce()
	pass

func _applyForce():
	get_tree().call_group(0,C.GROUP_BALL,"_applyForce",inputPos)
	pass
