class_name GateHex
extends Node2D

@export var direction: Utils.Direction : set = _set_direction
@onready var gate_sprite: Sprite2D = $GateSprite

var coordinate: Vector2i

var rotations := {
	Utils.Direction.TOP_RIGHT: 0,
	Utils.Direction.MID_RIGHT: deg_to_rad(60),
	Utils.Direction.BOT_RIGHT: deg_to_rad(120),
	Utils.Direction.BOT_LEFT: deg_to_rad(180),
	Utils.Direction.MID_LEFT: deg_to_rad(240),
	Utils.Direction.TOP_LEFT: deg_to_rad(300),
}

# Return an array of Coordinate and Direction pairs that dictate where the route should go.
# For example CoordDir { coordinate = Vector2i(0, 0), input_dir = Utils.Direction.MID_RIGHT }
# Means that the agent should traverse to MID_RIGHT from (0, 0)
func get_outputs(input_dir: Utils.Direction) -> Array[CoordDir]:
	var next = CoordDir.new(coordinate, input_dir)
	return [next]

func _set_direction(value: Utils.Direction) -> void:
	direction = value
	global_rotation = rotations[value]
