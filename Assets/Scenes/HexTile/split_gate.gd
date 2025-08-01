class_name SplitGate
extends GateHex

func get_outputs(ball: Ball) -> Array[CoordDir]:
	if get_direction_from_dir_vec(ball._head_dir) == hex_tile.direction:
		var left_dir = posmod(hex_tile.direction - 1, 6) # Get direction to the left
		var right_dir = posmod(hex_tile.direction + 1, 6) # Get direction to the right
		return [
			CoordDir.new(hex_tile.coordinate, left_dir),
			CoordDir.new(hex_tile.coordinate, right_dir)
		]
	else:
		return super.get_outputs(ball)
