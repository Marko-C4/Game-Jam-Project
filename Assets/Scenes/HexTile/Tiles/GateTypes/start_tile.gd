class_name StartTile
extends GateHex

func get_outputs(ball: Ball) -> Array[CoordDir]:
	var input_dir = get_direction_from_dir_vec(ball._head_dir)
	return [CoordDir.new(hex_tile.coordinate, input_dir)]
