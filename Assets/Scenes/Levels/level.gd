class_name Level
extends Node2D

const MAX_DEPTH := 640
const TILE_MATCHES_FOR_LOOP := 3

@onready var hex_map: HexMap = $HexMap
@onready var gates: Node2D = $HexMap/Gates

@onready var gate_ui: GateUI = %GateUI
@onready var level_overlay: LevelOverlay = %LevelOverlay
@onready var balls: Node = $HexMap/Balls

const SPLITTER_TUTORIAL = preload("res://Assets/Scenes/Stage/splitter_tutorial.tscn")

const BALL = preload("res://Assets/Scenes/Ball/ball.tscn")

var start_tiles: Array[HexTile] = []
var holding: Dictionary[Global.GATE_TYPE, int]
var current_stage: Stage = null
var simulation_mode = false

func _ready() -> void:
	_load_level(SPLITTER_TUTORIAL)
	gate_ui.gate_clicked.connect(_on_gate_ui_hex_button_pressed)
	
	level_overlay.start_stop_button_pressed.connect(_on_start_stop_button_pressed)
	level_overlay.reset_button_pressed.connect(_reload_level)
	level_overlay.step_forward_button_pressed.connect(step_forward)
	level_overlay.step_backward_button_pressed.connect(step_backward)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset_stage"):
		_reload_level()
		
	if event.is_action_pressed('ui_accept'):
		start_full_simulation()
		
	if event.is_action_pressed("step_simulation"):
		step_forward()
	

func _reload_level() -> void:
	start_tiles = []
	for gate: HexTile in get_tree().get_nodes_in_group('hex_gate'):
		gate.queue_free()
	for ball in get_tree().get_nodes_in_group('ball'):
		ball.queue_free()
	hex_map.gates.clear()
	end_simulation()

	for fixed_tile_data in current_stage.fixed_tiles:
		var fixed_tile := fixed_tile_data.create_instance(gates)
		fixed_tile.fixed_in_place = true
		fixed_tile.dnd.enabled = false # Disable dragging
		hex_map.add_gate(fixed_tile, fixed_tile_data.coordinate)
		if (fixed_tile.gate_type == Global.GATE_TYPE.START_GATE):
			start_tiles.append(fixed_tile)
	
	holding = current_stage.placeable.duplicate()
	gate_ui.update_ui(holding)

func _load_level_from_id(level_id: String) -> void:
	if current_stage:
		current_stage.queue_free()
	_load_level(Global.LEVELS[level_id])

func _load_level(level_scene: PackedScene):
	current_stage = level_scene.instantiate()
	hex_map.add_child(current_stage)
	hex_map.terrain = current_stage._placeable_terrain
	
	hex_map.global_scale = Vector2(current_stage.map_scale, current_stage.map_scale)
	
	_reload_level()


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
	for ball in get_tree().get_nodes_in_group('ball'):
		ball.queue_free()
	
	_initialize_simulation()
	for ball: Ball in get_tree().get_nodes_in_group('ball'):
		if ball.tween:
			ball.tween.kill()
		ball.step_full()

func _initialize_simulation() -> void:
	if not simulation_mode:
		simulation_mode = true
		SignalBus.simulation.start.emit()
	if get_tree().get_node_count_in_group('ball') == 0:
		for start_tile in start_tiles:
			var ball = BALL.instantiate()
			balls.add_child(ball)
			ball.global_position = start_tile.global_position
			ball._start_coord = start_tile.coordinate
			ball._start_dir = HexUtils.cube_to_axial(HexUtils.NEIGHBOR_DIRS[start_tile.direction])

func step_backward() -> void:
	_initialize_simulation()
	for ball: Ball in get_tree().get_nodes_in_group('ball'):
		if ball.tween:
			ball.tween.kill()
		ball.undo_step()

func step_forward() -> void:
	_initialize_simulation()
	for ball: Ball in get_tree().get_nodes_in_group('ball'):
		if ball.tween:
			ball.tween.kill()
		ball.step()

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
