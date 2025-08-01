class_name Stage
extends Node2D

@export_category("Stage Data")
@export var stage_name: String
@export var world_number: int
@export var stage_number: int

@export_category("Gate Data")
@export var fixed_tiles: Array[HexData]

# Type of gate and the number the player can place
@export var placeable: Dictionary[Global.GATE_TYPE, int]

@onready var _placeable_terrain: TileMapLayer = $PlaceableTerrain

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug1"):
		var coord = _placeable_terrain.local_to_map(_placeable_terrain.get_local_mouse_position())
		print_debug("Clicked Hex at ", coord)
