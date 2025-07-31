class_name Ball
extends Node2D

@onready var hex_map: HexMap = $"../HexMap"

var tween: Tween

var _start_coord: Vector2i
var _path_index: int
var _path: Array[Vector2i]
var is_loop = false

func reset() -> void:
	if tween:
		tween.kill()

func set_path(new_path: Array[Vector2i]) -> void:
	_path_index = 0
	_path = new_path
	is_loop = new_path[new_path.size() - 1] == _start_coord

func advance_to_next_tile(infinite: bool):
	if _path_index == _path.size() and not is_loop:
		return
	if _path.is_empty():
		return
		
	_path_index %= _path.size()

	var target_pos := hex_map.to_global(hex_map.terrain.map_to_local(_path[_path_index]))
	var prev_coord = Vector2i(0, 0) if _path_index == 0 else _path[_path_index - 1]
	var time := HexUtils.axial_distance(prev_coord, _path[_path_index]) * 0.2
	tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, time).from_current()
	
	tween.tween_callback(func():
		_path_index = _path_index + 1
		if infinite:
			advance_to_next_tile(infinite)
	)
