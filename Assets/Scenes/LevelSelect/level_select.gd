class_name LevelSelect
extends Control

@onready var vbox = $VBoxContainer
@onready var back_button = $VBoxContainer/BackButton
@onready var level_buttons := [
	$VBoxContainer/Level1Button,
	$VBoxContainer/Level2Button,
	$VBoxContainer/Level3Button,
	$VBoxContainer/Level4Button,
	$VBoxContainer/Level5Button,
	$VBoxContainer/Level6Button,
	$VBoxContainer/Level7Button
]

func _ready():
	back_button.text = "← Back to Main Menu"
	#back_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	back_button.modulate = Color(0.2, 0.8, 0.2)  
	back_button.pressed.connect(_on_back_pressed)

	for i in range(level_buttons.size()):
		var button = level_buttons[i]
		button.text = "Level %d" % (i + 1)
		button.pressed.connect(_on_level_pressed.bind(i + 1))
		
		var base_red = 1.0
		var base_green = 0.4
		var base_blue = 0.4
		var step = 0.05 * i

		var red = clamp(base_red - step, 0.7, 1.0)
		var green = clamp(base_green - step, 0.1, 0.4)
		var blue = clamp(base_blue - step, 0.1, 0.4)

		button.modulate = Color(red, green, blue)
		button.modulate = Color(red, 0.1, 0.1)

func _on_back_pressed():
	print("Going back to main menu")
	get_tree().change_scene_to_file("res://Assets/Scenes/MainMenu/MainMenu.tscn")

func _on_level_pressed(level_number: int) -> void:
	print("Loading Level %d..." % level_number)
	if level_number == 1:
		var scene_path = "res://Assets/Scenes/Level/level.tscn"
		get_tree().change_scene_to_file(scene_path)
