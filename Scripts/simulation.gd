extends Node2D

@export var GridSizeX : int
@export var GridSizeY : int
@export var CellSize : float

@onready var drawMesh: MeshInstance2D = $MeshInstance2D
var drawShaderMaterial : ShaderMaterial

var fluidGrid : FluidGrid

var viewState : int = 1

func _ready() -> void:
	fluidGrid = FluidGrid.new(GridSizeX, GridSizeY, CellSize)
	drawShaderMaterial = drawMesh.material as ShaderMaterial
	drawShaderMaterial.set_shader_parameter("gridSize", Vector2i(GridSizeX, GridSizeY))

func _physics_process(delta: float) -> void:
	
	fluidGrid.deltaTime = 1.0 / 60.0
	fluidGrid.UpdateVelocities()
	
	if Input.is_action_just_pressed("View1"): viewState = 1
	if Input.is_action_just_pressed("View2"): viewState = 2
	if Input.is_action_just_pressed("View3"): viewState = 3
	
	if viewState == 1:
		drawShaderMaterial.set_shader_parameter("gridTexture", fluidGrid.drawGridDivergence())
	elif viewState == 2:
		drawShaderMaterial.set_shader_parameter("gridTexture", ImageTexture.create_from_image(fluidGrid.gridPressureImage))
	elif viewState == 3:
		drawShaderMaterial.set_shader_parameter("gridTexture", ImageTexture.create_from_image(fluidGrid.gridStateImage))
	for i in GridSizeX:
		for j in GridSizeY:
			fluidGrid.PressureSolveCell(i, j)
