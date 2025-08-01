class_name DebugDrawCoordinates
extends Node2D

@export var limit: int
@export var offset: Vector2 :
	set(value):
		offset = value
		queue_redraw()
	
@export var tile_map: TileMapLayer

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	
	@warning_ignore("integer_division")
	for q in range(-limit, limit + 1):
		for r in range(-limit, limit + 1):
			if abs(q + r) > limit:
				continue
			var local_pos := tile_map.map_to_local(Vector2i(q, r))
			var pos := tile_map.to_global(local_pos) + offset - global_position
			draw_string(ThemeDB.fallback_font, pos, "(%d, %d)" % [q, r],
				HORIZONTAL_ALIGNMENT_CENTER, 80, 16, Color(0,0,0,0.5))
