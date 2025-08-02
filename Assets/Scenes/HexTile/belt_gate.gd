class_name BeltGate
extends GateHex

func get_outputs(ball: Ball) -> Array[CoordDir]:
	var dir_vex = HexUtils.cube_to_axial(HexUtils.NEIGHBOR_DIRS[direction])
	var next = CoordDir.new(hex_tile.coordinate + dir_vex, -1)
	ball._path.append(next.coord)
	return [ next ]
