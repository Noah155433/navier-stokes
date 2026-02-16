extends Resource

class_name FluidGrid

var CellCountX : int
var CellCountY : int
var CellSize : float

var velocitiesX : Velocities
var velocitiesY : Velocities

var gridDivergenceImage : Image
var gridDivergenceTexture : ImageTexture

func _init(cellCountX : int, cellCountY : int, cellSize : float) -> void:
	
	CellCountX = cellCountX
	CellCountY = cellCountY
	CellSize = cellSize
	
	gridDivergenceImage = Image.create(cellCountX, cellCountY, false, Image.FORMAT_RGB8)
	gridDivergenceTexture = ImageTexture.create_from_image(gridDivergenceImage)
	
	velocitiesX = Velocities.new(cellCountX + 1, cellCountY)
	velocitiesY = Velocities.new(cellCountX, cellCountY + 1)

func getVelocityAverage(x : int, y : int) -> float:
	var velocity : float = 0.0
	velocity -= velocitiesX.getVelocity(x, y)
	velocity -= velocitiesX.getVelocity(x + 1, y)
	velocity -= velocitiesY.getVelocity(x, y)
	velocity -= velocitiesY.getVelocity(x, y + 1)
	return velocity / 4

func getDivergenceColor(x : int, y : int) -> Color:
	var color : float = getVelocityAverage(x, y)
	if color < 0.0: 
		return Color(0, 0, abs(color))
	else:
		return Color(color, 0, 0)
	

func drawGridDivergence() -> ImageTexture:
	for i in CellCountX:
		for j in CellCountY:
			gridDivergenceImage.set_pixel(i, j, getDivergenceColor(i, j))
	gridDivergenceTexture.update(gridDivergenceImage)
	return gridDivergenceTexture
