class_name SplitGate
extends GateHex

var DIR_TO_SPRITE := {
	Utils.Direction.TOP_RIGHT: Vector2(0, 2),
	Utils.Direction.MID_RIGHT: Vector2(1, 0),
	Utils.Direction.BOT_RIGHT: Vector2(0, 1),
	Utils.Direction.BOT_LEFT: Vector2(1, 1),
	Utils.Direction.MID_LEFT: Vector2(0, 0),
	Utils.Direction.TOP_LEFT: Vector2(1, 2),
}

@onready var sprite_2d: Sprite2D = $Sprite2D

func set_hex_rotation(dir: Utils.Direction) -> void:
	var atlas_pos = DIR_TO_SPRITE[dir] * Vector2(Global.GATE_ATLAS_X_OFFSET, Global.GATE_ATLAS_Y_OFFSET) * Global.GATE_ATLAS_SEPARATION
	sprite_2d.texture.region.position = DIR_TO_SPRITE[dir] * Vector2(Global.GATE_ATLAS_X_OFFSET, Global.GATE_ATLAS_Y_OFFSET)
	global_rotation = 0

func get_outputs(ball: Ball) -> Array[CoordDir]:
	if get_direction_from_dir_vec(ball._head_dir) == hex_tile.direction:
		var left_dir = posmod(hex_tile.direction - 1, 6) # Get direction to the left
		var right_dir = posmod(hex_tile.direction + 1, 6) # Get direction to the right
		return [
			CoordDir.new(hex_tile.coordinate, left_dir),
			CoordDir.new(hex_tile.coordinate, right_dir)
		]
	else:
		return super.get_outputs(ball)
