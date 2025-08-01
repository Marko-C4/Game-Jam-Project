class_name ArrowGate
extends GateHex

func get_outputs(ball: Ball) -> Array[CoordDir]:
	return [CoordDir.new(hex_tile.coordinate, hex_tile.direction)]
