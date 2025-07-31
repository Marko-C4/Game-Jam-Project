class_name StartTile
extends GateHex

func get_outputs(_input_dir: Utils.Direction) -> Array[CoordDir]:
	return [CoordDir.new(coordinate, direction)]
