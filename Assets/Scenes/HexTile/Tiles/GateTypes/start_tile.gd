class_name StartTile
extends GateHex

func get_outputs(input_dir: Utils.Direction) -> Array[CoordDir]:
	return [CoordDir.new(hex_tile.coordinate, input_dir)]
