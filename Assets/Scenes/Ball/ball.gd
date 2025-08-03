class_name Ball
extends Node2D

@onready var hex_map: HexMap = $"../.."

var tween: Tween

var _start_gate: StartTile

var _head_dir: Vector2i
var _path_index: int
var _path: Array[Vector2i]
var is_loop = false
var special_movement: Dictionary[int, Global.GATE_TYPE] = {}

func reset() -> void:
	if tween:
		tween.kill()

func move_to(target: Vector2i, infinite = false):
	var target_pos := hex_map.to_global(hex_map.terrain.map_to_local(target))
	if special_movement.has(_path_index):
		match special_movement[_path_index]:
			Global.GATE_TYPE.TELEPORT_GATE:
				tween = create_tween()
				tween.parallel().tween_property(self, "global_rotation", deg_to_rad(360), 0.25)
				tween.parallel().tween_property(self, "scale", Vector2(0.1, 0.1), 0.25)
				tween.tween_callback(func():
					scale = Vector2(1, 1)
					global_position = hex_map.to_global(hex_map.terrain.map_to_local(target))
					if infinite:
						step(infinite)
				)
			Global.GATE_TYPE.BOUNCY_GATE:
				tween = create_tween()
				tween.parallel().tween_property(self, "global_position", target_pos, 0.40)
				tween.parallel().tween_property(self, "global_rotation", deg_to_rad(360), 0.40)
				tween.parallel().tween_property(self, "scale", Vector2(2, 2), 0.10)
				tween.tween_property(self, "scale", Vector2(1, 1), 0.10)
				tween.tween_callback(func():
					if infinite:
						step(infinite)
				)
				#var real_target_pos := hex_map.to_global(hex_map.terrain.map_to_local(target))
				#global_position = real_target_pos
				#if infinite:
					#call_deferred("step", infinite)
					
	else:
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
		_head_dir = HexUtils.cube_to_axial(HexUtils.NEIGHBOR_DIRS[_start_gate.direction])
		_path.append(current_hex + _head_dir)
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
	clone._path = _path.duplicate()
	clone._path_index = _path_index
	clone._head_dir = _head_dir
	self.get_parent().add_child(clone)
	return clone
