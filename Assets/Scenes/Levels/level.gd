class_name Level
extends Node2D

const MAX_DEPTH := 640
const TILE_MATCHES_FOR_LOOP := 3

@export var load_first_level = false
@export var multi_ghost_mode = false

@onready var hex_map: HexMap = $HexMap
@onready var gates: Node2D = $HexMap/Gates

@onready var dialog_layer: CanvasLayer = $DialogLayer
@onready var speaker_name: Label = $DialogLayer/Dialog/ColorRect/MarginContainer/VBoxContainer/SpeakerName
@onready var dialog: Label = $"DialogLayer/Dialog/DialogueBox/VBoxContainer/Dialog"
@onready var timer: Timer = $Timer

@onready var gate_ui: GateUI = %GateUI
@onready var level_overlay: LevelOverlay = %LevelOverlay
@onready var balls: Node = $HexMap/Balls
@onready var stage_label: Label = %StageLabel

@onready var win_label: VBoxContainer = %WinLabelContainer
@onready var lose_label: VBoxContainer = %LoseLabelContainer

@onready var hex_map_pos := hex_map.global_position

const BALL = preload("res://Assets/Scenes/Ball/ball.tscn")
var og_balls: Array[Ball] = []

var holding: Dictionary[Global.GATE_TYPE, int]
var current_stage: Stage = null
var simulation_mode = false

var dialog_index: int
var current_dialog: Array[String]

func _ready() -> void:
	if load_first_level:
		_load_level(Levels.get_first_stage())
	gate_ui.gate_clicked.connect(_on_gate_ui_hex_button_pressed)
	
	level_overlay.start_stop_button_pressed.connect(_on_start_stop_button_pressed)
	level_overlay.reset_button_pressed.connect(_reload_level)
	level_overlay.step_forward_button_pressed.connect(step_forward)
	level_overlay.step_backward_button_pressed.connect(step_backward)
	level_overlay.prev_level_button_pressed.connect(_load_prev_level)
	level_overlay.next_level_button_pressed.connect(_load_next_level)
	if multi_ghost_mode:
		timer.timeout.connect(_spawn_souls_and_step_full)

func _input(event: InputEvent) -> void:
	if dialog_layer.visible:
		if event.is_action_pressed('spacebar'):
			_advance_dialog()
		return
	
	if event.is_action_pressed("reset_stage"):
		_reload_level()

	if event.is_action_pressed('spacebar'):
		_on_start_stop_button_pressed()
	
	if event.is_action_pressed("spacebar"):
		if win_label.visible:
			_load_next_level()

	if event.is_action_pressed("debug1"):
		hex_map._toggle_at_mouse()
	if event.is_action_pressed("debug2"):
		current_stage.queue_free()
		_load_level(preload("res://Assets/Scenes/Stage/test_stage_4.tscn"))
		
	if event.is_action_pressed("ctrl_n"):
		_load_next_level()
	if event.is_action_pressed("ctrl_b"):
		_load_prev_level()

func _process(delta: float) -> void:
	if simulation_mode and not win_label.visible:
		if check_win_condition():
			timer.stop()
			win_label.visible = true
	if simulation_mode and not lose_label.visible:
		if check_lose_condition():
			timer.stop()
			lose_label.visible = true

func _reload_level() -> void:
	win_label.visible = false
	lose_label.visible = false
	for gate: HexTile in get_tree().get_nodes_in_group('hex_gate'):
		gate.free()
	for ball in get_tree().get_nodes_in_group('ball'):
		ball.queue_free()
	hex_map.gates.clear()
	end_simulation()

	for fixed_tile_data in current_stage.fixed_tiles:
		if not fixed_tile_data:
			continue
		
		var fixed_tile := fixed_tile_data.create_instance(gates)
		fixed_tile.set_fixed()
		fixed_tile.dnd.enabled = false # Disable dragging
		hex_map.add_gate(fixed_tile, fixed_tile_data.coordinate)
	
	holding = current_stage.placeable.duplicate()
	gate_ui.update_ui(holding)

func _load_level_from_id(level_id: String) -> void:
	if current_stage:
		current_stage.queue_free()
	_load_level(Global.LEVELS[level_id])

func _load_level(level_scene: PackedScene):
	current_stage = level_scene.instantiate()
	stage_label.text = current_stage.stage_name
	if not stage_label.text:
		stage_label.text = 'No Stage Name :('
	hex_map.add_child(current_stage)
	hex_map.global_position = hex_map_pos + current_stage.offset
	hex_map.terrain = current_stage._placeable_terrain
	
	hex_map.global_scale = Vector2(current_stage.map_scale, current_stage.map_scale)
	MusicController.play_stage_music(Levels.current_world_num)
	
	dialog_index = 0
	current_dialog = current_stage.level_dialog
	_update_dialog_ui()
	
	_reload_level()

func _load_prev_level():
	var prev_level = Levels.get_prev_level()
	current_stage.queue_free()
	_load_level(prev_level)

func _load_next_level():
	var next_level = Levels.get_next_level()
	current_stage.queue_free()
	_load_level(next_level)

func _register_hex_tile(hex: HexTile) -> void:
	hex.dnd.drag_started.connect(_on_dnd_drag_started.bind(hex))
	hex.dnd.drag_dropped.connect(_on_dnd_drag_dropped.bind(hex))
	hex.dnd.drag_canceled.connect(_on_dnd_drag_canceled.bind(hex))

func check_win_condition() -> bool:
	if get_tree().get_nodes_in_group('ball').size() == 0:
		return false
		
	var all_looping = get_tree().get_nodes_in_group('ball').all(
		func(ball: Ball):
			return ball.is_loop
	)

	var all_flags = get_tree().get_nodes_in_group('flag').all(
		func(flag: FlagGate):
			if not flag.visible:
				return true
			return flag.checked
	)
	
	return all_looping and all_flags


func check_lose_condition() -> bool:
	if get_tree().get_nodes_in_group('ball').size() == 0:
		return false

	var all_done = get_tree().get_nodes_in_group('ball').all(
		func(ball: Ball):
			return ball.is_done
	)
	var all_looping = get_tree().get_nodes_in_group('ball').all(
		func(ball: Ball):
			return ball.is_loop
	)

	var no_flags = get_tree().get_node_count_in_group('flag')
	var all_flags = get_tree().get_nodes_in_group('flag').all(
		func(flag: FlagGate):
			if not flag.visible:
				return true
			return flag.checked
	)
	return all_done and (not all_looping or (all_looping and  not all_flags))

func end_simulation() -> void:
	simulation_mode = false
	lose_label.visible = false
	timer.stop()
	SignalBus.simulation.end.emit()
	for ball in get_tree().get_nodes_in_group('ball'):
		ball.queue_free()

func start_full_simulation() -> void:
	for ball in get_tree().get_nodes_in_group('ball'):
		ball.queue_free()
	
	_initialize_simulation()

	_spawn_souls_and_step_full()
	timer.start()

func _initialize_simulation() -> void:
	if not simulation_mode:
		simulation_mode = true
		SignalBus.simulation.start.emit()

func _spawn_souls_and_step_full() -> Array[Ball]:
	var new_balls = _spawn_souls()
	for ball: Ball in new_balls:
		if ball.tween:
			ball.tween.kill()
		ball.step_full()
	return new_balls
	
func _spawn_souls() -> Array[Ball]:
	var new_balls: Array[Ball] = []
	for start_tile: StartTile in get_tree().get_nodes_in_group("start_gate"):
		if not start_tile.visible:
			continue # Not visible == not active 
		var ball = BALL.instantiate()
		new_balls.append(ball)
		balls.add_child(ball)
		ball.global_position = start_tile.global_position
		ball._start_gate = start_tile
	return new_balls

func step_backward() -> void:
	_initialize_simulation()
	if get_tree().get_node_count_in_group('ball') == 0:
		_spawn_souls()
	for ball: Ball in get_tree().get_nodes_in_group('ball'):
		if ball.tween:
			ball.tween.kill()
		ball.undo_step()

func step_forward() -> void:
	_initialize_simulation()
	if get_tree().get_node_count_in_group('ball') == 0:
		_spawn_souls()
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

func _update_dialog_ui() -> void:
	if dialog_index >= current_dialog.size():
		dialog_layer.visible = false
	else:
		dialog_layer.visible = true
		dialog.text = current_dialog[dialog_index]

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

func _advance_dialog():
	dialog_index += 1
	_update_dialog_ui()

func _on_dialog_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse1"):
		_advance_dialog()
