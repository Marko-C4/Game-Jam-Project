# class_name Levels
extends Node

# World 1
var BASIC_1 = load("res://Assets/Scenes/Stage/BasicLevels/basic_1.tscn")  # 1
var BASIC_2 = load("res://Assets/Scenes/Stage/BasicLevels/basic_2.tscn")  # 1
var BASIC_3 = load("res://Assets/Scenes/Stage/BasicLevels/basic_3.tscn")  # 1
var BASIC_4 = load("res://Assets/Scenes/Stage/BasicLevels/basic_4.tscn")  # 2
var BASIC_5 = load("res://Assets/Scenes/Stage/BasicLevels/basic_5.tscn")  # 2

# World 2
var SPLITTER_1 = load("res://Assets/Scenes/Stage/SplitterStages/splitter_1.tscn") # 1
var SPLITTER_2 = load("res://Assets/Scenes/Stage/SplitterStages/splitter_2.tscn") # 1
var SPLITTER_3 = load("res://Assets/Scenes/Stage/SplitterStages/splitter_3.tscn") # 3
var SPLITTER_4 = load("res://Assets/Scenes/Stage/SplitterStages/splitter_4.tscn") # 3
var SPLITTER_5 = load("res://Assets/Scenes/Stage/SplitterStages/splitter_5.tscn") # 3

# World 3
var BOUNCY_1 = load("res://Assets/Scenes/Stage/BouncyLevels/bouncy_1.tscn") # 1
var BOUNCY_2 = load("res://Assets/Scenes/Stage/BouncyLevels/bouncy_2.tscn") # 1
var BOUNCY_3 = load("res://Assets/Scenes/Stage/BouncyLevels/bouncy_3.tscn") # 2
var BOUNCY_4 = load("res://Assets/Scenes/Stage/BouncyLevels/bouncy_4.tscn") # 2
var BOUNCY_5 = load("res://Assets/Scenes/Stage/BouncyLevels/bouncy_5.tscn") # 2

# World 4
var TELEPORTER_1 = load("res://Assets/Scenes/Stage/Teleporter_Stages/teleporter_1.tscn") # 2
var TELEPORTER_2 = load("res://Assets/Scenes/Stage/Teleporter_Stages/teleporter_2.tscn") # 2
var TELEPORTER_3 = load("res://Assets/Scenes/Stage/Teleporter_Stages/teleporter_3.tscn") # 3
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
#var TURN_3 = load("res://Assets/Scenes/Stage/TurnStages/turn_3.tscn")
#var TURN_4 = load("res://Assets/Scenes/Stage/TurnStages/turn_4.tscn")
#var TURN_5 = load("res://Assets/Scenes/Stage/TurnStages/turn_5.tscn")

# Random
var ASTIN = load("res://Assets/Scenes/Stage/ChallengingLevels/astinkivi.tscn")
var AXIS = load("res://Assets/Scenes/Stage/ChallengingLevels/Axis.tscn")
var LUMIHIUTALE = load("res://Assets/Scenes/Stage/ChallengingLevels/lumihiutale.tscn")
var PULLACHALLENGE = load("res://Assets/Scenes/Stage/ChallengingLevels/pulla_challenge.tscn")
var PYRATELE = load("res://Assets/Scenes/Stage/ChallengingLevels/pyramid_tele.tscn")
var SUPERVAIKEE = load("res://Assets/Scenes/Stage/ChallengingLevels/super_vaikee.tscn")
var UFO = load("res://Assets/Scenes/Stage/ChallengingLevels/ufo.tscn")

var RANDOM_STAGES: Array[PackedScene] = [
	ASTIN,
	AXIS,
	LUMIHIUTALE,
	PULLACHALLENGE,
	PYRATELE,
	SUPERVAIKEE,
	UFO
]

# World 1
#var BASIC_1 = load("res://Assets/Scenes/Stage/BasicLevels/basic_1.tscn")  # 1
#var BASIC_2 = load("res://Assets/Scenes/Stage/BasicLevels/basic_2.tscn")  # 1
#var BASIC_3 = load("res://Assets/Scenes/Stage/BasicLevels/basic_3.tscn")  # 1
#var BASIC_4 = load("res://Assets/Scenes/Stage/BasicLevels/basic_4.tscn")  # 2
#var BASIC_5 = load("res://Assets/Scenes/Stage/BasicLevels/basic_5.tscn")  # 2

var ARROW_STAGES: Array[PackedScene] = [
	BASIC_1,
	BASIC_2,
	BASIC_3,
	BASIC_4,
	BASIC_5,
]

# World 2
#　var SPLITTER_1 = load("res://Assets/Scenes/Stage/SplitterStages/splitter_1.tscn") # 1
#　var SPLITTER_2 = load("res://Assets/Scenes/Stage/SplitterStages/splitter_2.tscn") # 1
#　var SPLITTER_3 = load("res://Assets/Scenes/Stage/SplitterStages/splitter_3.tscn") # 3
#　var SPLITTER_4 = load("res://Assets/Scenes/Stage/SplitterStages/splitter_4.tscn") # 3
#　var SPLITTER_5 = load("res://Assets/Scenes/Stage/SplitterStages/splitter_5.tscn") # 3

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
	GROUND_1, # HEARTBROKEN
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
	#TURN_3,
	#TURN_4,
	# TURN_5,
]

	#ASTIN,
	#AXIS,
	#LUMIHIUTALE,
	#PULLACHALLENGE,
	#PYRATELE,
	#SUPERVAIKEE,
	#UFO
	
var LEVEL_1:  Array[PackedScene] = [
	BASIC_1,
	BASIC_2,
	BASIC_3,
	BASIC_4,
	BASIC_5,
]	

var LEVEL_2:  Array[PackedScene] = [
	SPLITTER_1,
	SPLITTER_2,
	BOUNCY_1,
	BOUNCY_2,
	BOUNCY_3,
]

var LEVEL_3:  Array[PackedScene] = [
	TELEPORTER_2,
	GROUND_1, # HEARTBROKEN
	TELEPORTER_3,
	BOUNCY_4,
	TELEPORTER_3_5,
]

var LEVEL_4:  Array[PackedScene] = [
	GROUND_2, # Rupture
	BELT_1,
	BELT_2,
	BELT_3,
	BELT_4,
]
	
var LEVEL_5:  Array[PackedScene] = [
	TURN_1,
	SPLITTER_4,
	TELEPORTER_4, # LEAP Of Faith
	BOUNCY_5, # FOUR FACTIONS
]
	
var LEVEL_6:  Array[PackedScene] = [
	SPLITTER_3,
	PULLACHALLENGE,
	BELT_5,
]

var LEVEL_7:  Array[PackedScene] = [
	SPLITTER_5,
	UFO, # TROLLI TURN
	PYRATELE,
]

var LEVEL_8:  Array[PackedScene] = [
	TURN_2, # TROLLI TURN
	LUMIHIUTALE,
	ASTIN,
]

var LEVEL_9:  Array[PackedScene] = [
	TELEPORTER_5, # HELLAGON
	AXIS,
	SUPERVAIKEE,
]


#var WORLDS = [
	#ARROW_STAGES,
	#SPLITTER_STAGES,
	#BOUNCY_STAGES,
	#TELEPORTER_STAGES,
	#GROUND_STAGES,
	#BELT_STAGES,
	#TURN_STAGES,
	#RANDOM_STAGES
#]

var WORLDS = [
	LEVEL_1,
	LEVEL_2,
	LEVEL_3,
	LEVEL_4,
	LEVEL_5,
	LEVEL_6,
	LEVEL_7,
	LEVEL_8,
	LEVEL_9
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
	
	if current_world_num >= WORLDS.size():
		return null
	
	return WORLDS[current_world_num][current_stage_num]
