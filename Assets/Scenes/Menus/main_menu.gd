class_name MainMenu
extends Control

@onready var center = $CenterContainer
@onready var vbox = $CenterContainer/VBoxContainer
@onready var start_button = $CenterContainer/VBoxContainer/StartButton
@onready var start_button_2: Button = $CenterContainer/VBoxContainer/StartButton2
@onready var options_button = $CenterContainer/VBoxContainer/OptionsButton
@onready var quit_button = $CenterContainer/VBoxContainer/QuitButton

@onready var fadeout: ColorRect = $Fadeout

var common_level_scene = load("res://Assets/Scenes/Levels/level_1.tscn")

func _ready():
	MusicController.play_menu_music()
	var button_min_size = Vector2(400, 100)
	for button in [start_button, start_button_2, options_button, quit_button]:
		button.custom_minimum_size = button_min_size
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
	start_button.text = "Play"
	start_button_2.text = "Level Select"
	options_button.text = "Options"
	quit_button.text = "Quit"

	start_button.pressed.connect(_on_start_game_first_level)
	start_button_2.pressed.connect(_on_start_game)
	options_button.pressed.connect(_on_options)
	quit_button.pressed.connect(_on_quit)


func _on_start_game_first_level():
	var tw = create_tween()
	tw.tween_property(fadeout, "color", Color(0, 0, 0, 1), 1)
	tw.tween_callback(func():
		var common_level_scene_instance = common_level_scene.instantiate()
		common_level_scene_instance.load_first_level = true
		get_tree().root.add_child(common_level_scene_instance)
		hide()
	)

func _on_start_game():
	print("_on_start_game")
	get_tree().change_scene_to_file("res://Assets/Scenes/Menus/GridLevelSelect.tscn")

func _on_options():
	print("_on_options")
	get_tree().change_scene_to_file("res://Assets/Scenes/Menus/Options.tscn")

func _on_quit():
	print("_on_quit")
	get_tree().quit()
