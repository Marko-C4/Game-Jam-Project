class_name Level
extends Node2D

const MAX_DEPTH := 100

@export var level_data: LevelData

@onready var hex_map: HexMap = $HexMap
@onready var gates: Node2D = $HexMap/Gates

# Probably Temporary
@onready var ball: Ball = $Ball
@onready var gate_ui: GateUI = %GateUI

var start_tile: HexTile
var holding: Dictionary[Global.GATE_TYPE, int]

func _ready() -> void:
	_load_level()
	_load_overlay()
	gate_ui.gate_clicked.connect(_on_gate_ui_hex_button_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset_stage"):
		_reload_level()
		print(self.get_global_mouse_position())
		
	if event.is_action_pressed('ui_accept'):
		test_path()
	

func _reload_level() -> void:
	for gate: HexTile in get_tree().get_nodes_in_group('hex_gate'):
		hex_map.remove_gate(gate)
		gate.queue_free()
	ball.reset()
	ball.global_position = start_tile.global_position
	SignalBus.simulation.end.emit()
	_load_level()
	
func _load_overlay() -> void:
	var overlay_scene = preload("res://Assets/Scenes/LevelOverlay/LevelOverlay.tscn")
	#var overlay_instance = overlay_scene.instantiate()
	#add_child(overlay_instance)

func _load_level() -> void:
	assert(level_data)
	
	start_tile = level_data.start_tile.create_instance(gates)
	start_tile.fixed_in_place = true
	start_tile.dnd.enabled = false # Disable dragging
	hex_map.add_gate(start_tile, level_data.start_tile.coordinate)
	
	for fixed_tile_data in level_data.fixed_tiles:
		var fixed_tile := fixed_tile_data.create_instance(gates)
		fixed_tile.fixed_in_place = true
		fixed_tile.dnd.enabled = false # Disable dragging
		hex_map.add_gate(fixed_tile, fixed_tile_data.coordinate)
	
	holding = level_data.placeable.duplicate()
	gate_ui.update_ui(holding)

func _register_hex_tile(hex: HexTile) -> void:
	hex.dnd.drag_started.connect(_on_dnd_drag_started.bind(hex))
	hex.dnd.drag_dropped.connect(_on_dnd_drag_dropped.bind(hex))
	hex.dnd.drag_canceled.connect(_on_dnd_drag_canceled.bind(hex))

func test_path() -> void:
	SignalBus.simulation.start.emit()
	var done = false
	var depth = 0
	var current_dir := start_tile.direction
	var current_hex := start_tile.coordinate
	var path: Array[Vector2i] = []
	while not done and depth < MAX_DEPTH:
		if not hex_map.is_travesible(current_hex):
			print("Illegal path")
			done = true
			continue
		
		var hex = hex_map.try_get_gate(current_hex)
		if not hex:
			current_hex = HexUtils.cube_to_axial(HexUtils.get_cell_in_dir(current_hex, current_dir))
		else:
			var gate := hex.get_gate()
			if is_instance_of(gate, StartTile) and hex.direction == current_dir and depth > 0:
				done = true
				print("Looping path!!")
				continue
			
			var coord_dirs = gate.get_outputs(current_dir)
			current_dir = coord_dirs[0].dir
			var start_hex = coord_dirs[0].coord
			current_hex = HexUtils.cube_to_axial(HexUtils.get_cell_in_dir(start_hex, current_dir))
		path.append(current_hex)
		depth += 1
	print(path)
	var is_loop = path[path.size() - 1] == start_tile.coordinate
	ball.set_path(path, is_loop)

func _put_gate_to_holding(hex: HexTile) -> void:
	gate_ui.return_gate(hex.gate_type)
	hex.queue_free()

func _on_dnd_drag_started(hex: HexTile) -> void:
	hex_map.remove_gate(hex)

func _on_dnd_drag_canceled(starting_position: Vector2, hex: HexTile) -> void:
	hex.global_position = starting_position
	_put_gate_to_holding(hex)

func _on_dnd_drag_dropped(starting_position: Vector2, hex: HexTile) -> void:
	var success = hex_map.drop_gate(hex, hex.global_position - hex.dnd.offset)
	if not success:
		_put_gate_to_holding(hex)

func _on_gate_ui_hex_button_pressed(type: Global.GATE_TYPE) -> void:
	if get_tree().get_nodes_in_group('dragging'):
		return
	
	gate_ui.take_gate(type)
	var hex_cell = HexData.create_instance_from_type(gates, type)
	_register_hex_tile(hex_cell)
	hex_cell.global_position = self.get_global_mouse_position()
	hex_cell.dnd._start_dragging()
