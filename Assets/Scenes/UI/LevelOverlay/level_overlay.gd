class_name LevelOverlay
extends Control

signal start_stop_button_pressed
signal reset_button_pressed
signal step_backward_button_pressed
signal step_forward_button_pressed
signal prev_level_button_pressed
signal next_level_button_pressed

const BUTTON_WIDTH = 150
const BUTTON_HEIGHT = 50
const ARROW_BUTTON_WIDTH = 45

@onready var back_button = $MarginContainer/HBoxContainer/BackToLevelSelectButton
@onready var start_stop_button = $MarginContainer/HBoxContainer/StartStopButton
@onready var step_forward_button = $MarginContainer/HBoxContainer/StepForwardButton
@onready var step_backward_button = $MarginContainer/HBoxContainer/StepBackwardButton
@onready var reset_button = $MarginContainer/HBoxContainer/ResetButton
@onready var prev_level_button: Button = $MarginContainer/HBoxContainer/PrevLevelButton
@onready var next_level_button: Button = $MarginContainer/HBoxContainer/NextLevelButton
@onready var score = $Score

func _ready():	
	start_stop_button.text = "Start (S)"

	back_button.custom_minimum_size = Vector2(BUTTON_WIDTH, BUTTON_HEIGHT)
	back_button.text = "Level Select (Esc)"

	start_stop_button.custom_minimum_size = Vector2(BUTTON_WIDTH, BUTTON_HEIGHT)

	step_forward_button.custom_minimum_size = Vector2(ARROW_BUTTON_WIDTH, BUTTON_HEIGHT)
	step_forward_button.text = "(→)"

	step_backward_button.custom_minimum_size = Vector2(ARROW_BUTTON_WIDTH, BUTTON_HEIGHT)
	step_backward_button.text = "(←)"

	reset_button.custom_minimum_size = Vector2(BUTTON_WIDTH, BUTTON_HEIGHT)
	reset_button.text = "Reset (Q)"
	
	prev_level_button.custom_minimum_size = Vector2(BUTTON_WIDTH, BUTTON_HEIGHT)
	prev_level_button.text = "Prev Level (P)"
	
	next_level_button.custom_minimum_size = Vector2(BUTTON_WIDTH, BUTTON_HEIGHT)
	next_level_button.text = "Next Level (N)"

	back_button.pressed.connect(_on_back_pressed)
	start_stop_button.pressed.connect(_on_start_stop_pressed)
	step_forward_button.pressed.connect(_on_step_forward_pressed)
	step_backward_button.pressed.connect(_on_step_backward_pressed)
	reset_button.pressed.connect(_on_reset_pressed)
	prev_level_button.pressed.connect(
		func(): prev_level_button_pressed.emit()
	)
	next_level_button.pressed.connect(
		func(): next_level_button_pressed.emit()
	)
	
	SignalBus.simulation.start.connect(
		func(): start_stop_button.text = "Stop (X)"
	)
	SignalBus.simulation.end.connect(
		func(): start_stop_button.text = "Start (S)"
	)

func _on_back_pressed():
	get_parent().get_parent().queue_free()

	var level_select = load("res://Assets/Scenes/Menus/GridLevelSelect.tscn").instantiate()
	get_tree().root.add_child(level_select)


func _on_start_stop_pressed():
	start_stop_button_pressed.emit()

func _on_step_forward_pressed():
	step_forward_button_pressed.emit()

func _on_step_backward_pressed():
	step_backward_button_pressed.emit()

func _on_reset_pressed():
	reset_button_pressed.emit()

func update_score(points: int):
	score.text = "Score: " + str(points)
