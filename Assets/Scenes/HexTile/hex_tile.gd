class_name HexTile
extends Node2D

@export var direction: Utils.Direction : set = _set_direction

var rotations := {
	Utils.Direction.TOP_RIGHT: 0,
	Utils.Direction.MID_RIGHT: deg_to_rad(60),
	Utils.Direction.BOT_RIGHT: deg_to_rad(120),
	Utils.Direction.BOT_LEFT: deg_to_rad(180),
	Utils.Direction.MID_LEFT: deg_to_rad(240),
	Utils.Direction.TOP_LEFT: deg_to_rad(300),
}

func get_outputs(input_dir: Utils.Direction) -> Array[Utils.Direction]:
	return [input_dir]

func _set_direction(value: Utils.Direction) -> void:
	direction = value
	global_rotation = rotations[value]
