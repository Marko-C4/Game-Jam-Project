extends Node

var menu_music = load("res://Assets/Music/Somber_infernal.wav")
var limbo_music = load("res://Assets/Music/Limbo.wav")

func play_menu_music():
	if $Music.stream != menu_music:
		$Music.stream = menu_music
		$Music.play()

func play_limbo_music():
	if $Music.stream != limbo_music:
		$Music.stream = limbo_music
		$Music.play()
