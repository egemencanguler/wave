
extends Sprite


func _ready():
	set_process(true)
	get_node("Timer").start(1)
#	set_pos(Vector2(0,0))
#	set_scale(get_viewport().get_size_override())


func _process(delta):
	var nt = get_node("Timer").getNormalizedTimeLeft()
	set_opacity(nt)



func _on_Timer_timesUp():
	queue_free()
	pass # replace with function body
