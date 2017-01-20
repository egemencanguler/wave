
extends Node2D

const Bullet = preload("res://game/character/bullet.tscn")
var dir = Vector2()
var cooldown = false
func _ready():
	set_fixed_process(true)
	pass


func _fixed_process(delta):
	dir = get_global_mouse_pos() - get_global_pos()
	update()


func _draw():
	draw_line(Vector2(), dir, Color(1,0,0,1))
	pass


func shoot():
	if cooldown:
		return
	else:
		cooldown = true
		get_node("CooldownTimer").start()
	print("Shoot")
	var b = Bullet.instance()
	add_child(b)
	b.set_global_pos(get_global_pos())
	b.apply_impulse(Vector2(), dir)
	pass


func _on_CooldownTimer_timeout():
	cooldown = false
	pass # replace with function body
