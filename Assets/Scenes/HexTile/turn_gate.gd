class_name TurnGate
extends GateHex

@onready var sprite_2d: Sprite2D = $Sprite2D

var flipped = false

func set_hex_rotation(dir: Utils.Direction) -> void:
	sprite_2d.flip_h = flipped
	flipped = not flipped
	global_rotation = 0

func get_outputs(ball: Ball) -> Array[CoordDir]:
	var ball_dir = get_direction_from_dir_vec(ball._head_dir)
	var left_dir = posmod(ball_dir - 1, 6) # Get direction to the left
	var right_dir = posmod(ball_dir + 1, 6) # Get direction to the right
	if flipped:
		return [ CoordDir.new(hex_tile.coordinate, right_dir) ]
	else:
		return [ CoordDir.new(hex_tile.coordinate, left_dir) ]
