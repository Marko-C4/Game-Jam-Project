class_name BouncyGate
extends GateHex

func get_outputs(ball: Ball) -> Array[CoordDir]:
	var next = CoordDir.new(hex_tile.coordinate + ball._head_dir * 2, -1)
	ball._path.append(next.coord)
	return [ next ]
