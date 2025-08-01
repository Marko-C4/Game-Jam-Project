class_name Level
extends Node2D

const MAX_DEPTH := 100
const TILE_MATCHES_FOR_LOOP := 3

@export var level_data: LevelData

@onready var hex_map: HexMap = $HexMap
@onready var gates: Node2D = $HexMap/Gates

@onready var gate_ui: GateUI = %GateUI
@onready var level_overlay: LevelOverlay = %LevelOverlay

const BALL = preload("res://Assets/Scenes/Level/Ball/ball.tscn")

var start_tiles: Array[HexTile] = []
var holding: Dictionary[Global.GATE_TYPE, int]
var simulation_mode = false

func _ready() -> void:
	_load_level()
	_load_overlay()
	gate_ui.gate_clicked.connect(_on_gate_ui_hex_button_pressed)
	
	level_overlay.start_stop_button_pressed.connect(_on_start_stop_button_pressed)
	level_overlay.reset_button_pressed.connect(_reload_level)
	level_overlay.step_forward_button_pressed.connect(simulate_step.bind(false))
	level_overlay.step_backward_button_pressed.connect(simulate_step.bind(true))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset_stage"):
		_reload_level()
		
	if event.is_action_pressed('ui_accept'):
		start_full_simulation()
		
	if event.is_action_pressed("step_simulation"):
		simulate_step(false)
	

func _reload_level() -> void:
	start_tiles = []
	for gate: HexTile in get_tree().get_nodes_in_group('hex_gate'):
		hex_map.remove_gate(gate)
		gate.queue_free()
	for ball in get_tree().get_nodes_in_group('ball'):
		ball.queue_free()
	end_simulation()
	_load_level()
	
func _load_overlay() -> void:
	var overlay_scene = preload("res://Assets/Scenes/LevelOverlay/LevelOverlay.tscn")
	#var overlay_instance = overlay_scene.instantiate()
	#add_child(overlay_instance)

func _load_level() -> void:
	assert(level_data)
	
	for fixed_tile_data in level_data.fixed_tiles:
		var fixed_tile := fixed_tile_data.create_instance(gates)
		fixed_tile.fixed_in_place = true
		fixed_tile.dnd.enabled = false # Disable dragging
		hex_map.add_gate(fixed_tile, fixed_tile_data.coordinate)
		if (fixed_tile.gate_type == Global.GATE_TYPE.START_GATE):
			start_tiles.append(fixed_tile)
	
	holding = level_data.placeable.duplicate()
	gate_ui.update_ui(holding)

func _register_hex_tile(hex: HexTile) -> void:
	hex.dnd.drag_started.connect(_on_dnd_drag_started.bind(hex))
	hex.dnd.drag_dropped.connect(_on_dnd_drag_dropped.bind(hex))
	hex.dnd.drag_canceled.connect(_on_dnd_drag_canceled.bind(hex))

func end_simulation() -> void:
	simulation_mode = false
	SignalBus.simulation.end.emit()
	for ball in get_tree().get_nodes_in_group('ball'):
		ball.queue_free()

func start_full_simulation() -> void:
	start_simulation()
	for ball: Ball in get_tree().get_nodes_in_group('ball'):
		ball.advance_to_next_tile(true)

func start_simulation() -> void:
	end_simulation()
	for start_tile in start_tiles:
		var path = test_path(start_tile)
		var is_loop = path[path.size() - 1] == start_tile.coordinate
		
		var ball = BALL.instantiate()
		self.add_child(ball)
		ball.global_position = start_tile.global_position
		ball._start_coord = start_tile.coordinate
		ball.set_path(path)

func simulate_step(backwards: bool) -> void:
	if get_tree().get_node_count_in_group('ball') == 0:
		start_simulation()
	
	for ball: Ball in get_tree().get_nodes_in_group('ball'):
		ball.advance_to_next_tile(false, backwards)

func is_looping(path: Array[Vector2i]) -> bool:
	if len(path) > 2:
		for i in range(len(path) - TILE_MATCHES_FOR_LOOP - 1):
			var looping := true
			for j in range(TILE_MATCHES_FOR_LOOP):
				if path[i + j] != path.slice(-TILE_MATCHES_FOR_LOOP, len(path))[j]:
					looping = false
					break
			if looping:
				level_overlay.update_score(len(path) - i - TILE_MATCHES_FOR_LOOP)
				return true
	return false
	

func test_path(start_tile: HexTile) -> Array[Vector2i]:
	simulation_mode = true
	SignalBus.simulation.start.emit()
	var done = false
	var depth = 0
	var current_dir := start_tile.direction
	var current_hex := start_tile.coordinate
	var path: Array[Vector2i] = [current_hex]
	while not done and depth < MAX_DEPTH:
		if not hex_map.is_travesible(current_hex):
			print_debug("Illegal path")
			done = true
			continue
		
		var hex = hex_map.try_get_gate(current_hex)
		if not hex:
			current_hex = HexUtils.cube_to_axial(HexUtils.get_cell_in_dir(current_hex, current_dir))
		else:
			var gate := hex.get_gate()
			if is_looping(path):
				done = true
				continue
			
			var coord_dirs = gate.get_outputs(current_dir)
			current_dir = coord_dirs[0].dir
			var start_hex = coord_dirs[0].coord
			current_hex = HexUtils.cube_to_axial(HexUtils.get_cell_in_dir(start_hex, current_dir))
		path.append(current_hex)
		depth += 1
	
	print(path)
	return path

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

func _on_start_stop_button_pressed() -> void:
	if simulation_mode:
		end_simulation()
	else:
		start_full_simulation()
