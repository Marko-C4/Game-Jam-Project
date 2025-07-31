class_name Level
extends Node

const MAX_DEPTH := 100

@export var level_data: LevelData

@onready var hex_map: HexMap = $HexMap
@onready var gates: Node2D = $HexMap/Gates
@onready var ball: Ball = $Ball

var start_tile: HexTile

func _ready() -> void:
	start_tile = level_data.start_tile.create_instance(gates)
	hex_map.add_gate(start_tile, level_data.start_tile.coordinate)
	
	for fixed_tile_data in level_data.fixed_tiles:
		var fixed_tile := fixed_tile_data.create_instance(gates)
		hex_map.add_gate(fixed_tile, fixed_tile_data.coordinate)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_accept'):
		test_path()

func test_path() -> void:
	var done = false
	var depth = 0
	var current_dir := start_tile.direction
	var current_hex := Vector2i(0, 0) # TODO: allow start to be anywhere
	var path: Array[Vector2i] = []
	while not done and depth < MAX_DEPTH:
		if not hex_map.is_travesible(current_hex):
			print("Illegal path")
			done = true
			continue
		
		var gate = hex_map.try_get_gate(current_hex)
		if not gate:
			current_hex = HexUtils.cube_to_axial(HexUtils.get_cell_in_dir(current_hex, current_dir))
		else:
			if is_instance_of(gate, StartTile) and depth > 0:
				done = true
				continue
			
			var dirs = gate.get_outputs(start_tile.direction)
			current_dir = dirs[0]
			current_hex = HexUtils.cube_to_axial(HexUtils.get_cell_in_dir(current_hex, dirs[0]))
		path.append(current_hex)
		depth += 1
	print(path)
	var is_loop = path[path.size() - 1] == Vector2i(0, 0)
	ball.set_path(path, is_loop)
