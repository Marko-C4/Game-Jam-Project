class_name StartTile
extends GateHex

var DIR_TO_SPRITE := {
	Utils.Direction.TOP_RIGHT: Vector2(4, 2),
	Utils.Direction.MID_RIGHT: Vector2(5, 0),
	Utils.Direction.BOT_RIGHT: Vector2(4, 1),
	Utils.Direction.BOT_LEFT: Vector2(5, 1),
	Utils.Direction.MID_LEFT: Vector2(4, 0),
	Utils.Direction.TOP_LEFT: Vector2(5, 2),
}

@onready var sprite_2d: Sprite2D = $Sprite2D

func set_hex_rotation(dir: Utils.Direction) -> void:
	var separation = DIR_TO_SPRITE[dir] * Global.GATE_ATLAS_SEPARATION
	sprite_2d.texture.region.position = separation + DIR_TO_SPRITE[dir] * Vector2(Global.GATE_ATLAS_X_OFFSET, Global.GATE_ATLAS_Y_OFFSET)
	global_rotation = 0

func get_outputs(ball: Ball) -> Array[CoordDir]:
	var input_dir = get_direction_from_dir_vec(ball._head_dir)
	return [CoordDir.new(hex_tile.coordinate, input_dir)]
