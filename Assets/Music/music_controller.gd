extends Node

var menu_music = load("res://Assets/Music/Somber_infernal.wav")
var limbo_music = load("res://Assets/Music/Limbo.wav")
var fraud_music = load("res://Assets/Music/Fraud.wav")

func play_menu_music() -> void:
	if $Music.stream != menu_music:
		$Music.stream = menu_music
		$Music.play()

func play_stage_music(stage_num: int) -> void:
	match stage_num:
		0:
			if $Music.stream != limbo_music:
				$Music.stream = limbo_music
				$Music.play()
		5:
			if $Music.stream != fraud_music:
				$Music.stream = fraud_music
				$Music.play()
		_:
			if $Music.stream != menu_music:
				$Music.stream = menu_music
				$Music.play()
