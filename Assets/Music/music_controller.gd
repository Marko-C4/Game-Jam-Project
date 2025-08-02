extends Node

var menu_music = load("res://Assets/Music/Somber_infernal.wav")

func play_menu_music():
	if $Music.stream != menu_music:
		$Music.stream = menu_music
		$Music.play()
