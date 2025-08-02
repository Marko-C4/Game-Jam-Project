class_name HexMap
extends Node2D

var terrain: TileMapLayer

var gates: Dictionary[Vector2i, HexTile] = {}

# Return whether drop was succesful
func drop_gate(gate: HexTile, global_pos: Vector2) -> bool:
	var coordinate := global_to_map(global_pos)
	if not try_get_gate(coordinate):
		if gate.gate_type == Global.GATE_TYPE.GROUND_GATE:
			if can_drop_ground(coordinate):
				add_gate(gate, coordinate)
				return true
			else:
				return false
		if is_travesible(coordinate):
			add_gate(gate, coordinate)
			return true
	return false

func remove_gate(gate: HexTile) -> void:
	var key = gates.find_key(gate)
	if key != null:
		gates.erase(key)

func add_gate(gate: HexTile, coordinate: Vector2i) -> void:
	gate.coordinate = coordinate
	gates[coordinate] = gate
	gate.global_position = terrain.to_global(terrain.map_to_local(coordinate))

func is_travesible(coordinate: Vector2i) -> bool:
	return terrain.get_cell_tile_data(coordinate) != null or gates.has(coordinate)

func try_get_gate(coordinate: Vector2i) -> HexTile:
	if not gates.has(coordinate):
		return null
	return gates[coordinate]

func global_to_map(global_pos: Vector2) -> Vector2i:
	return terrain.local_to_map(terrain.to_local(global_pos))
	
func get_hovered_tile() -> Vector2i:
	return terrain.local_to_map(terrain.get_local_mouse_position())

func _toggle_at_mouse():
	var coord = terrain.local_to_map(terrain.get_local_mouse_position())
	if terrain.get_cell_tile_data(coord):
		terrain.set_cell(coord)
	else:
		terrain.set_cell(coord, 1, Vector2i(2, 3))
	
func can_drop_ground(coordinate: Vector2i) -> bool:
	if not is_travesible(coordinate) and HexUtils.get_neighbors(coordinate).any(
		func(coord):
			print(is_travesible(coord))
			return is_travesible(coord)
	):
		return true
	else:
		return false
