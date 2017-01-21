
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
var time = 0
var timer = 0
var start = false
var useScaledTime = false
signal timesUp()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	setProcess()
	pass

func setProcessFixed():
	set_fixed_process(true)
	set_process(false)

func setProcess():
	set_fixed_process(false)
	set_process(true)

func start(t):
	time = t
	timer = t
	start = true

func stop():
	timer = 0
	time = 0
	start = false

func _process(delta):
	_timerProcess(delta)

func _fixed_process(delta):
	_timerProcess(delta)

func _timerProcess(delta):
	if useScaledTime:
		timer -= delta
	else:
		timer -= delta / OS.get_time_scale()
	if timer <= 0 and start:
		start = false
		emit_signal("timesUp")

func getTimeLeft():
	return time

func getNormalizedTimeLeft():
	if !start:
		return 0
	# 1 - 0
	return timer/time

func getDenormalizedTimeLeft():
	# 0 - 1
	if !start:
		return 1
	return 1 - (timer/time)
