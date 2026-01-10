extends Node2D


@export var cell_size = Vector2i(64,64)

@onready var grass: TileMapLayer = $Grass
@onready var road: TileMapLayer = $Road

var grass_cell :Array
var road_cell :Array
var path :Array
var astargrid = AStarGrid2D.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_grid()

func setup_grid():
	astargrid.region = grass.get_used_rect()
	astargrid.cell_size = cell_size
	astargrid.offset = cell_size/2
	astargrid.diagonal_mode = astargrid.DIAGONAL_MODE_NEVER
	astargrid.update()
	grass_cell = grass.get_used_cells()
	road_cell = road.get_used_cells()
	
	for cell in grass_cell:
		if cell not in road_cell:
			astargrid.set_point_solid(cell)
	
	
	
func get_road_path(pos1, pos2):
	var map_pos1 = road.local_to_map(pos1)
	var map_pos2 = road.local_to_map(pos2)
	path = astargrid.get_point_path(map_pos1,map_pos2)
	return path
