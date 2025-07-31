class_name Ball
extends Node2D

@onready var hex_map: HexMap = $"../HexMap"

var tween: Tween

var _path_index: int
var _path: Array[Vector2i]

func set_path(new_path: Array[Vector2i], loop: bool) -> void:
	_path_index = 0
	_path = new_path
	advance_to_next_tile(loop)

func advance_to_next_tile(loop: bool):
	if _path.is_empty():
		return

	var target_pos := hex_map.to_global(hex_map.terrain.map_to_local(_path[_path_index]))
	var time := HexUtils.axial_distance(
		_path[posmod(_path_index - 1, _path.size())],
		_path[_path_index]
	) * 0.2
	tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, time).from_current()
	
	tween.tween_callback(func():
		_path_index = (_path_index + 1) % _path.size()
		if _path_index == 0 and not loop:
			return
		advance_to_next_tile(loop)
	)
