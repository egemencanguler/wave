
extends Sprite


var remove = false
func _ready():
	get_node("SamplePlayer2D").play("shockwave")
	set_process(true)
	get_node("Timer").start(1)
#	set_pos(Vector2(0,0))
#	set_scale(get_viewport().get_size_override())


func _process(delta):
	if remove:
		set_opacity(get_node("Timer").getNormalizedTimeLeft())
	else:
		var dnt = get_node("Timer").getDenormalizedTimeLeft()
		dnt += 5 + dnt * 5
		set_scale(Vector2(dnt,dnt))



func _on_Timer_timesUp():
	if remove:
		queue_free()
	else:
		remove = true
		get_node("Timer").start(0.5)
	pass # replace with function body
