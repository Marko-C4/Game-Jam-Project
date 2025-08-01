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

func advance_to_next_tile(infinite: bool, backwards = false):
	if not backwards and _path_index == _path.size() - 1 and not is_loop:
		return
	if backwards and _path_index == 0 and not is_loop:
		return
	if _path.is_empty():
		return
	
	var _prev_path_index := _path_index
	_path_index = posmod(_path_index + (-1 if backwards else 1), _path.size())

	var target_pos := hex_map.to_global(hex_map.terrain.map_to_local(_path[_path_index]))
	var time := HexUtils.axial_distance(_path[_prev_path_index], _path[_path_index]) * 0.2
	tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, time).from_current()
	
	tween.tween_callback(func():
		if infinite:
			advance_to_next_tile(infinite)
	)
