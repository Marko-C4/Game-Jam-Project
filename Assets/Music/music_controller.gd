extends Node

var menu_music = load("res://Assets/Music/Somber_infernal.wav")
var limbo_music = load("res://Assets/Music/Limbo.wav")
var lust_music = load("res://Assets/Music/Lust.wav")
var gluttony_music = load("res://Assets/Music/Gluttony.wav")
var wrath_music = load("res://Assets/Music/Wrath.wav")
var violence_music = load("res://Assets/Music/Violence.wav")
var fraud_music = load("res://Assets/Music/Fraud.wav")
var treachery_music = load("res://Assets/Music/Treachery.wav")

func play_menu_music() -> void:
	if $Music.stream != menu_music:
		$Music.stream = menu_music
		$Music.play()

func play_stage_music(stage_num: int) -> void:
	var music = menu_music
	match stage_num:
		0:
			music = limbo_music
		1:
			music = lust_music 
		2:
			music = gluttony_music
		4:
			music = wrath_music
		6: 
			music = violence_music
		7:
			music = fraud_music
		8:
			music = treachery_music
		_:
			music = menu_music
			
	if $Music.stream != music:
				$Music.stream = music
				$Music.play()
