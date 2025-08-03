# class_name Levels
extends Node

# World 1
var BASIC_1 = load("res://Assets/Scenes/Stage/BasicLevels/basic_1.tscn")
var BASIC_2 = load("res://Assets/Scenes/Stage/BasicLevels/basic_2.tscn")
var BASIC_3 = load("res://Assets/Scenes/Stage/BasicLevels/basic_3.tscn")
var BASIC_4 = load("res://Assets/Scenes/Stage/BasicLevels/basic_4.tscn")
var BASIC_5 = load("res://Assets/Scenes/Stage/BasicLevels/basic_5.tscn")

# World 2
var SPLITTER_1 = load("res://Assets/Scenes/Stage/SplitterStages/splitter_1.tscn")
var SPLITTER_2 = load("res://Assets/Scenes/Stage/SplitterStages/splitter_2.tscn")
var SPLITTER_3 = load("res://Assets/Scenes/Stage/SplitterStages/splitter_3.tscn")
var SPLITTER_4 = load("res://Assets/Scenes/Stage/SplitterStages/splitter_4.tscn")
var SPLITTER_5 = load("res://Assets/Scenes/Stage/SplitterStages/splitter_5.tscn")

# World 3
var BOUNCY_1 = load("res://Assets/Scenes/Stage/BouncyLevels/bouncy_1.tscn")
var BOUNCY_2 = load("res://Assets/Scenes/Stage/BouncyLevels/bouncy_2.tscn")
var BOUNCY_3 = load("res://Assets/Scenes/Stage/BouncyLevels/bouncy_3.tscn")
var BOUNCY_4 = load("res://Assets/Scenes/Stage/BouncyLevels/bouncy_4.tscn")
var BOUNCY_5 = load("res://Assets/Scenes/Stage/BouncyLevels/bouncy_5.tscn")

# World 4
var TELEPORTER_1 = load("res://Assets/Scenes/Stage/Teleporter_Stages/teleporter_1.tscn")
var TELEPORTER_2 = load("res://Assets/Scenes/Stage/Teleporter_Stages/teleporter_2.tscn")
var TELEPORTER_3 = load("res://Assets/Scenes/Stage/Teleporter_Stages/teleporter_3.tscn")
var TELEPORTER_3_5 =preload("res://Assets/Scenes/Stage/Teleporter_Stages/teleporter_3.5.tscn")
var TELEPORTER_4 = load("res://Assets/Scenes/Stage/Teleporter_Stages/teleporter_4.tscn")
var TELEPORTER_5 = load("res://Assets/Scenes/Stage/Teleporter_Stages/teleporter_5.tscn")

# World 5
var GROUND_1 = load("res://Assets/Scenes/Stage/GroundStages/ground_1.tscn")
var GROUND_2 = load("res://Assets/Scenes/Stage/GroundStages/ground_2.tscn")

# World 6
var BELT_1 = load("res://Assets/Scenes/Stage/BeltStages/belt_1.tscn")
var BELT_2 = load("res://Assets/Scenes/Stage/BeltStages/belt_2.tscn")
var BELT_3 = load("res://Assets/Scenes/Stage/BeltStages/belt_3.tscn")
var BELT_4 = load("res://Assets/Scenes/Stage/BeltStages/belt_4.tscn")
var BELT_5 = load("res://Assets/Scenes/Stage/BeltStages/belt_5.tscn")

# World 7
var TURN_1 = load("res://Assets/Scenes/Stage/TurnStages/turn_1.tscn")
var TURN_2 = load("res://Assets/Scenes/Stage/TurnStages/turn_2.tscn")
var TURN_3 = load("res://Assets/Scenes/Stage/TurnStages/turn_3.tscn")
var TURN_4 = load("res://Assets/Scenes/Stage/TurnStages/turn_4.tscn")
var TURN_5 = load("res://Assets/Scenes/Stage/TurnStages/turn_5.tscn")

# Random
var PULLA_CHALLENGE = load("res://Assets/Scenes/Stage/ChallengingLevels/pulla_challenge.tscn")
var PYRAMID_TELE = load("res://Assets/Scenes/Stage/ChallengingLevels/pyramid_tele.tscn")

var ARROW_STAGES: Array[PackedScene] = [
	BASIC_1,
	BASIC_2,
	BASIC_3,
	BASIC_4,
	BASIC_5,
]

var BOUNCY_STAGES: Array[PackedScene] = [
	BOUNCY_1,
	BOUNCY_2,
	BOUNCY_3,
	TELEPORTER_2,
	TELEPORTER_3,
]

var TELEPORTER_STAGES: Array[PackedScene] = [
	BOUNCY_4,
	TELEPORTER_3_5,
	TELEPORTER_4,
	BOUNCY_5,
	TELEPORTER_5,
]

var SPLITTER_STAGES: Array[PackedScene] = [
	SPLITTER_1,
	SPLITTER_2,
	SPLITTER_3,
	SPLITTER_4,
	SPLITTER_5,
]

var GROUND_STAGES: Array[PackedScene] = [
	GROUND_1,
	GROUND_2
]

var BELT_STAGES: Array[PackedScene] = [
	BELT_1,
	BELT_2,
	BELT_3,
	BELT_4,
	BELT_5,
]

var TURN_STAGES: Array[PackedScene] = [
	TURN_1,
	TURN_2,
	TURN_3,
	TURN_4,
	TURN_5,
]

var WORLDS = [
	ARROW_STAGES,
	SPLITTER_STAGES,
	BOUNCY_STAGES,
	TELEPORTER_STAGES,
	GROUND_STAGES,
	BELT_STAGES,
	TURN_STAGES,
]

var current_world_num := 0
var current_stage_num := 0

func get_first_stage() -> PackedScene:
	current_world_num = 0
	current_stage_num = 0
	return WORLDS[current_world_num][current_stage_num]

func get_stage(world: int, stage: int) -> PackedScene:
	current_world_num = world
	current_stage_num = stage
	return WORLDS[current_world_num][current_stage_num]

func get_prev_level() -> PackedScene:
	current_stage_num -= 1
	if current_stage_num < 0:
		current_world_num -= 1
		current_stage_num = WORLDS[current_world_num].size() - 1
	
	return WORLDS[current_world_num][current_stage_num]


func get_next_level() -> PackedScene:
	current_stage_num += 1
	if current_stage_num == WORLDS[current_world_num].size():
		current_world_num += 1
		current_stage_num = 0
	
	return WORLDS[current_world_num][current_stage_num]
