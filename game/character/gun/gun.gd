
extends Node2D

const Bullet = preload("res://game/character/gun/bullet.tscn")
const TEX_TARGET = preload("res://game/character/gun/target.png")
const TEX_BRAIN = preload("res://game/character/gun/brain.png")
const CHAR_WIDTH = 50

var bulletSpeed = 700
var dir = Vector2()
var cooldown = false
var texCursor = TEX_TARGET
func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	dir = get_global_mouse_pos() - get_global_pos()
	update()

func _draw():
#	draw_line(Vector2(),dir,Color(1,0,0,1))
	draw_texture(texCursor,dir-texCursor.get_size()/2)
	pass

func _mid(start, end):
	var dir = end - start
	return dir/2 - dir.rotated(-PI/2) / 3

func shoot():
	if cooldown:
		return
	else:
		cooldown = true
		get_node("CooldownTimer").start()
	print("Shoot")
	var b = Bullet.instance()
	get_tree().get_current_scene().add_child(b)
	var dn = dir.normalized()
	b.set_global_pos(get_global_pos() + dn * CHAR_WIDTH)
	b.apply_impulse(Vector2(), dir.normalized() * bulletSpeed)
	pass

func changeCursorBrain():
	texCursor = TEX_BRAIN

func changeCursorGun():
	texCursor = TEX_TARGET

func _on_CooldownTimer_timeout():
	cooldown = false
	pass # replace with function body
