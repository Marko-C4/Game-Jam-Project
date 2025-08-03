extends Control

func _ready():
	$CenterContainer/VBoxContainer/Button.pressed.connect(_on_Button_pressed)

func _on_Button_pressed():
	get_tree().change_scene("res://Assets/Scenes/Menus/MainMenu.tscn") 
