class_name GateHex
extends Node2D

var hex_tile: HexTile
var coordinate: Vector2i : get = _get_coord
var direction: Utils.Direction : get = _get_direction


func on_reset() -> void:
	pass

func on_place() -> void:
	pass
	
func on_remove() -> void:
	pass

# Return an array of Coordinate and Direction pairs that dictate where the route should go.
# For example CoordDir { coordinate = Vector2i(0, 0), input_dir = Utils.Direction.MID_RIGHT }
# Means that the agent should traverse to MID_RIGHT from (0, 0)
func get_outputs(ball: Ball) -> Array[CoordDir]:
	var input_dir = get_direction_from_dir_vec(ball._head_dir)
	var next = CoordDir.new(hex_tile.coordinate, input_dir)
	return [next]

func get_direction_from_dir_vec(dir_vec: Vector2i) -> Utils.Direction:
	return HexUtils.NEIGHBOR_DIRS.find(HexUtils.axial_to_cube(dir_vec))

func _get_coord() -> Vector2i:
	return hex_tile.coordinate
	
func _get_direction() -> Utils.Direction:
	return hex_tile.direction
