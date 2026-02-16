extends Node2D

@export var GridSizeX : int
@export var GridSizeY : int
@export var CellSize : float

@onready var drawMesh: MeshInstance2D = $MeshInstance2D
var drawShaderMaterial : ShaderMaterial

var fluidGrid : FluidGrid

func _ready() -> void:
	fluidGrid = FluidGrid.new(GridSizeX, GridSizeY, CellSize)
	drawShaderMaterial = drawMesh.material as ShaderMaterial
	drawShaderMaterial.set_shader_parameter("gridSize", Vector2i(GridSizeX, GridSizeY))

func _physics_process(delta: float) -> void:
	
	fluidGrid.deltaTime = delta
	fluidGrid.UpdateVelocities()
	for i in GridSizeX:
		for j in GridSizeY:
			fluidGrid.PressureSolveCell(i, j)
	drawShaderMaterial.set_shader_parameter("gridTexture", fluidGrid.drawGridDivergence())
	
