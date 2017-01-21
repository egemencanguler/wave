
extends StaticBody2D

# member variables here, example:
# var a=2
# var b="textvar"
var pol = Vector2Array()

var leftUpCorner = Vector2(0,0)
var pieceWidth = 10
var pieceHeight = 10
var verticalPieceNumber = 10
var horizontalPieceNumber = 10

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	#Top
	for i in range(horizontalPieceNumber):
		pol.append(leftUpCorner  + i * Vector2(pieceWidth * i, 0))
	var rightUpCorner = pol[pol.size() - 1]
	for i in range(verticalPieceNumber):
		pol.append(rightUpCorner + i * Vector2(0,pieceHeight * i))
	var rightDownCorner = pol[pol.size() - 1]
	for i in range(horizontalPieceNumber-1,-1,-1):
		pol.append(rightDownCorner + i * Vector2(pieceWidth * i,0))
	var leftDownCorner = pol[pol.size() - 1]
	for i in range(verticalPieceNumber-1,-1,-1):
		pol.append(leftDownCorner + Vector2(-pieceHeight * i,0))


func _draw():
	draw_colored_polygon(pol,Color(1,1,0,1))


