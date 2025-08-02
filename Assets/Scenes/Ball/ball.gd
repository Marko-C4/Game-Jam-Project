class_name Ball
extends Node2D

@onready var hex_map: HexMap = $"../.."

var tween: Tween

var _start_coord: Vector2i
var _start_dir: Vector2i
var _start_gate: StartTile

var _head_dir: Vector2i
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

func move_to(target: Vector2i, infinite = false):
	var target_pos := hex_map.to_global(hex_map.terrain.map_to_local(target))
	tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, 0.25)
	tween.tween_callback(func():
		if infinite:
			step(infinite)
	)

func undo_step():
	if _path_index  <= 1:
		print_debug("can't go beyond start")
		return
	
	_path_index -= 1
	move_to(_path[_path_index - 1])

func step_full() -> void:
	step(true)

func step(infinite = false):
	if _path.size() == 0:
		_path.append(hex_map.global_to_map(global_position))
		_path_index += 1
	
	var prev_hex = _path[_path_index - 2] if _path_index > 1 else Vector2i(0, 0)
	var current_hex = _path[_path_index - 1]
	if _path_index < _path.size(): # Traverse cached path
		move_to(_path[_path_index], infinite)
		_path_index += 1
		return
	elif not hex_map.is_travesible(current_hex): # Can't move
		print_debug("Illegal path")
		return
	elif _path_index == 1: # Special start of path stuff
		_path.append(current_hex + _start_dir)
		_head_dir = _start_dir
		move_to(_path[_path_index], infinite)
		_path_index += 1
		return
	else:
		var hex = hex_map.try_get_gate(current_hex)
		#var direction = Vector2i(current_hex.x - prev_hex.x, current_hex.y - prev_hex.y)
		if not hex:
			# Normal hex so go forwards
			_path.append(current_hex + _head_dir)
			move_to(_path[_path_index], infinite)
			_path_index += 1
			return
		else:
			# Gate so do special stuff
			var gate := hex.get_gate()
			
			# Loop check
			if (_has_looped(gate, _head_dir)):
				print_debug("Looping path!!")
				move_to(_path[1], infinite)
				_path_index = 2
				is_loop = true
				return
			
			var coord_dirs = gate.get_outputs(self)
			for index in coord_dirs.size():
				var coord_dir = coord_dirs[index]
				var ball_instance = self if index == coord_dirs.size() - 1 else _clone_self()

				if coord_dir.dir == -1: # The trust me bro branch
					ball_instance.move_to(ball_instance._path[_path_index], infinite)

					ball_instance._path_index += 1
					return
				
				var next_tile = HexUtils.cube_to_axial(HexUtils.get_cell_in_dir(coord_dir.coord, coord_dir.dir))
				ball_instance._head_dir = HexUtils.cube_to_axial(HexUtils.NEIGHBOR_DIRS[coord_dir.dir])
				ball_instance._path.append(next_tile)
				ball_instance.move_to(ball_instance._path[_path_index], infinite)

				ball_instance._path_index += 1

func _has_looped(gate: GateHex, direction: Vector2i) -> bool:
	return (
		gate == _start_gate and # Is start gate
		_path_index > 1 and # Is not start of path
		direction == Vector2i(_path[1].x - _path[0].x, _path[1].y - _path[0].y) # Is going the same direction as start
	)

func _clone_self() -> Ball:
	var clone := duplicate() as Ball
	clone._start_gate = _start_gate
	clone._start_coord = _start_coord
	clone._start_dir = _start_dir
	clone._path = _path.duplicate()
	clone._path_index = _path_index
	clone._head_dir = _head_dir
	self.get_parent().add_child(clone)
	return clone
