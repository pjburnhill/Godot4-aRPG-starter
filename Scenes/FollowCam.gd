extends Camera2D

@export var tilemap: TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	var mapRect = tilemap.get_used_rect()
	var mapTileSize = tilemap.cell_quadrant_size
	var mapSizeInPixels = mapRect.size * mapTileSize
	limit_right = mapSizeInPixels.x
	limit_bottom = mapSizeInPixels.y
