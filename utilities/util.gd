
extends Node

static func shuffle(array):
	for i in range(array.size()):
		var index = randi() % array.size()
		var t = array[index]
		array[index] = array[i]
		array[i] = t

static func discretizeVec(vec, startAngle, numberOfParts):
	var angle = vec.angle()
	if angle < 0:
		angle = 2 * PI + angle
	var normAngle = angle / 6
	var normStart = startAngle / (2*PI)
	angle = normAngle - normStart
	if angle < 0:
		angle = angle + 1
	angle = angle * numberOfParts
	return int(angle)


