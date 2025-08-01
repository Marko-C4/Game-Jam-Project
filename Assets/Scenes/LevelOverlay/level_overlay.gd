class_name LevelOverlay
extends Control

signal start_stop_button_pressed
signal reset_button_pressed
signal step_backward_button_pressed
signal step_forward_button_pressed

const BUTTON_WIDTH = 150
const BUTTON_HEIGHT = 50
const ARROW_BUTTON_WIDTH = 45

@onready var back_button = $MarginContainer/HBoxContainer/BackToLevelSelectButton
@onready var start_stop_button = $MarginContainer/HBoxContainer/StartStopButton
@onready var step_forward_button = $MarginContainer/HBoxContainer/StepForwardButton
@onready var step_backward_button = $MarginContainer/HBoxContainer/StepBackwardButton
@onready var reset_button = $MarginContainer/HBoxContainer/ResetButton
@onready var score = $Score

func _ready():
	var buttons = [
		back_button, start_stop_button,
		step_forward_button, step_backward_button, reset_button
	]
	
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

	back_button.pressed.connect(_on_back_pressed)
	start_stop_button.pressed.connect(_on_start_stop_pressed)
	step_forward_button.pressed.connect(_on_step_forward_pressed)
	step_backward_button.pressed.connect(_on_step_backward_pressed)
	reset_button.pressed.connect(_on_reset_pressed)
	
	SignalBus.simulation.start.connect(
		func():
			start_stop_button.text = "Stop (X)"
	)
	SignalBus.simulation.end.connect(
		func():
			start_stop_button.text = "Start (S)"
	)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Assets/Scenes/LevelSelect/LevelSelect.tscn")

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
