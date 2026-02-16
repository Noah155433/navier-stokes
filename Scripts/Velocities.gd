extends Resource

class_name Velocities

var velocities : Array[float]
var SizeX : int
var SizeY : int

func _init(sizeX : int, sizeY : int) -> void:
	SizeX = sizeX
	SizeY = sizeY 
	velocities.resize(sizeY * sizeX)
	for i in sizeX:
		for j in sizeY:
			setVelocity(i, j, randf_range(-1.0, 1.0))

func setVelocity (x : int, y : int, value : float) -> void:
	velocities[y * SizeX + x] = value

func getVelocity (x : int, y : int) -> float:
	return velocities[y * SizeX + x]
