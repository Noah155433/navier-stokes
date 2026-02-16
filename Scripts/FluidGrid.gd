extends Resource

class_name FluidGrid

var CellCountX : int
var CellCountY : int
var CellSize : float

var velocitiesX : Velocities
var velocitiesY : Velocities

var gridDivergenceImage : Image
var gridDivergenceTexture : ImageTexture

var gridPressureImage : Image
var gridPressureTexture : ImageTexture

var density : float = 1.0

var deltaTime : float = 0.0

func _init(cellCountX : int, cellCountY : int, cellSize : float) -> void:
	
	CellCountX = cellCountX
	CellCountY = cellCountY
	CellSize = cellSize
	
	gridDivergenceImage = Image.create(cellCountX, cellCountY, false, Image.FORMAT_RGB8)
	gridDivergenceTexture = ImageTexture.create_from_image(gridDivergenceImage)
	
	gridPressureImage = Image.create(cellCountX, cellCountY, false, Image.FORMAT_RGB8)
	gridPressureTexture = ImageTexture.create_from_image(gridPressureImage)
	
	velocitiesX = Velocities.new(cellCountX + 1, cellCountY)
	velocitiesY = Velocities.new(cellCountX, cellCountY + 1)

func CalculateVelocityDivergenceAtCell(x : int, y : int) -> float:
	var velocityTop : float = velocitiesY.getVelocity(x, y + 1)
	var velocityLeft : float = velocitiesX.getVelocity(x, y)
	var velocityRight : float = velocitiesX.getVelocity(x + 1, y)
	var velocityBottom : float = velocitiesY.getVelocity(x, y)
	
	var gradientX : float = (velocityRight - velocityLeft) / CellSize
	var gradientY : float = (velocityTop - velocityBottom) / CellSize
	
	var divergence : float = gradientX + gradientY
	return divergence

func GetPressure(x : int, y : int) -> float:
	var outOfBounds : bool = x < 0 or x >= CellCountX or y < 0 or y >= CellCountY
	return 0 if outOfBounds else gridPressureImage.get_pixel(x, y).r

func PressureSolveCell(x : int, y : int) -> void:
	
	var pressureTop : float = GetPressure(x + 0, y + 1)
	var pressureLeft : float = GetPressure(x - 1, y + 0)
	var pressureRight : float = GetPressure(x + 1, y + 0)
	var pressureBottom : float = GetPressure(x + 0, y - 1)
	
	var velocityTop : float = velocitiesY.getVelocity(x + 0, y + 1)
	var velocityLeft : float = velocitiesX.getVelocity(x + 0, y + 0)
	var velocityRight : float = velocitiesX.getVelocity(x + 1, y + 0)
	var velocityBottom : float = velocitiesY.getVelocity(x + 0, y + 0)
	
	var pressureSum : float = pressureRight + pressureLeft + pressureTop + pressureBottom
	var deltaVelocitySum = velocityRight - velocityLeft + velocityTop - velocityBottom
	
	var Pressure = (pressureSum - density * CellSize * deltaVelocitySum / deltaTime) / 4.0
	gridPressureImage.set_pixel(x, y, Color(Pressure, Pressure, Pressure))

func UpdateVelocities() -> void:
	var K : float = deltaTime / (density * CellSize)
	
	for x in velocitiesX.SizeX:
		for y in velocitiesX.SizeY:
			var pressureRight : float = GetPressure(x, y)
			var pressureLeft : float = GetPressure(x - 1, y)
			velocitiesX.setVelocity(x, y, velocitiesX.getVelocity(x, y) - K * (pressureRight - pressureLeft))
	
	for x in velocitiesY.SizeX:
		for y in velocitiesY.SizeY:
			var pressureTop : float = GetPressure(x, y)
			var pressureBottom : float = GetPressure(x, y - 1)
			velocitiesY.setVelocity(x, y, velocitiesY.getVelocity(x, y) - K * (pressureTop - pressureBottom))

func getDivergenceColor(x : int, y : int) -> Color:
	var color : float = CalculateVelocityDivergenceAtCell(x, y)
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
