
extends StaticBody2D

# member variables here, example:
# var a=2
# var b="textvar"
var pol = Vector2Array()
var polCons = Vector2Array()

var leftUpCorner = Vector2(0,0)
var pieceWidth = 30
var pieceHeight = 30
var verticalPieceNumber = 5
var horizontalPieceNumber = 5

func _ready():
	set_fixed_process(true)
	#Top
	for i in range(horizontalPieceNumber):
		pol.append(leftUpCorner + Vector2(pieceWidth * i, 0))
	var rightUpCorner = pol[pol.size() - 1]
	for i in range(1,verticalPieceNumber - 1):
		pol.append(rightUpCorner + Vector2(0,pieceHeight * i))
	var rightDownCorner = pol[pol.size() -1]
	rightDownCorner.y += pieceHeight
	for i in range(horizontalPieceNumber):
		pol.append(rightDownCorner + Vector2(-pieceWidth * i, 0))
	var leftDownCorner = pol[pol.size() - 1 ]
	for i in range(1,verticalPieceNumber -1):
		pol.append(leftDownCorner + Vector2(0, i * -pieceHeight))
	for p in pol:
		polCons.append(Vector2(p.x,p.y))
	print(pol)
	get_node("CollisionPolygon2D").set_polygon(pol)

var timer = 0
func _fixed_process(delta):
	timer += delta
	for i in range(pol.size()):
		pol[i].y = polCons[i].y + sin(timer + pol[i].x) * 300 * delta
	update()
	print(pol)

func _draw():
	draw_colored_polygon(pol,Color(1,0,0,1))




