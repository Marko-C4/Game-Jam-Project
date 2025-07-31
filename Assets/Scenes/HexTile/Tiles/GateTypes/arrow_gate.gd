class_name ArrowGate
extends GateHex

func get_outputs(_input_dir: Utils.Direction) -> Array[CoordDir]:
	return [CoordDir.new(hex_tile.coordinate, hex_tile.direction)]
