class_name ArrowGate
extends GateHex

@onready var sprite_2d: Sprite2D = $Sprite2D

var DIR_TO_SPRITE := {
	Utils.Direction.TOP_RIGHT: Vector2(2, 2),
	Utils.Direction.MID_RIGHT: Vector2(3, 0),
	Utils.Direction.BOT_RIGHT: Vector2(2, 1),
	Utils.Direction.BOT_LEFT: Vector2(3, 1),
	Utils.Direction.MID_LEFT: Vector2(2, 0),
	Utils.Direction.TOP_LEFT: Vector2(3, 2),
}

func set_hex_rotation(dir: Utils.Direction) -> void:
	var separation = DIR_TO_SPRITE[dir] * Global.GATE_ATLAS_SEPARATION
	sprite_2d.texture.region.position = separation + DIR_TO_SPRITE[dir] * Vector2(Global.GATE_ATLAS_X_OFFSET, Global.GATE_ATLAS_Y_OFFSET)
	global_rotation = 0

func get_outputs(ball: Ball) -> Array[CoordDir]:
	return [CoordDir.new(hex_tile.coordinate, hex_tile.direction)]
