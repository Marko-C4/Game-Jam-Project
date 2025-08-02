class_name MainMenu
extends Control

@onready var center = $CenterContainer
@onready var vbox = $CenterContainer/VBoxContainer
@onready var start_button = $CenterContainer/VBoxContainer/StartButton
@onready var options_button = $CenterContainer/VBoxContainer/OptionsButton
@onready var quit_button = $CenterContainer/VBoxContainer/QuitButton

func _ready():
	
	var button_min_size = Vector2(400, 100)
	for button in [start_button, options_button, quit_button]:
		button.custom_minimum_size = button_min_size
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
	start_button.text = "Play"
	options_button.text = "Options"
	quit_button.text = "Quit"

	start_button.pressed.connect(_on_start_game)
	options_button.pressed.connect(_on_options)
	quit_button.pressed.connect(_on_quit)


func _on_start_game():
	print("_on_start_game")
	get_tree().change_scene_to_file("res://Assets/Scenes/Menus/GridLevelSelect.tscn")

func _on_options():
	print("_on_options")
	get_tree().change_scene_to_file("res://Assets/Scenes/Menus/Options.tscn")

func _on_quit():
	print("_on_quit")
	get_tree().quit()
