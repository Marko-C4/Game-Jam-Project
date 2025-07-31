class_name GateHex
extends Node2D

var hex_tile: HexTile

# Return an array of Coordinate and Direction pairs that dictate where the route should go.
# For example CoordDir { coordinate = Vector2i(0, 0), input_dir = Utils.Direction.MID_RIGHT }
# Means that the agent should traverse to MID_RIGHT from (0, 0)
func get_outputs(input_dir: Utils.Direction) -> Array[CoordDir]:
	var next = CoordDir.new(hex_tile.coordinate, input_dir)
	return [next]
