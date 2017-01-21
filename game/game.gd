
extends Node2D

const C = preload("res://constants.gd")
const BG = preload("res://game/background/parallaxbackground.tscn")
export(int) var levelNumber = 1

func _ready():
	get_tree().call_group(0,C.GROUP_ENEMY,"connectPlayer",get_node("Character"))
	move_child(get_node("Character"),get_child_count()-1)
	get_node("Character").connect("die",self,"onCharacterDie")
	add_child(BG.instance())
	set_process(true)
	set_process_unhandled_input(true)
	pass

func _process(delta):
	var charPos = get_node("Character").get_global_pos()
	if charPos.x > 1280:
		get_tree().change_scene(getLevelPath(levelNumber + 1))

func onCharacterDie():
	gameOver()

func gameOver():
	get_tree().change_scene(getLevelPath(levelNumber))

func getLevelPath(levelNumber):
	return "res://game/level" + str(levelNumber) + ".tscn"

func _unhandled_input(event):
	if Input.is_key_pressed(KEY_R):
		gameOver()




