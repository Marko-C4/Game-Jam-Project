class_name SplitGate
extends GateHex

func get_outputs(_input_dir: Utils.Direction) -> Array[CoordDir]:
	var left_dir = posmod(hex_tile.direction - 1, 6) # Get direction to the left
	var right_dir = posmod(hex_tile.direction + 1, 6) # Get direction to the right
	return [
		CoordDir.new(hex_tile.coordinate, left_dir),
		CoordDir.new(hex_tile.coordinate, right_dir)
	]
