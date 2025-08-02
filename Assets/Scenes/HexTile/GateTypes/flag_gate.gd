class_name FlagGate
extends GateHex

@onready var flag_bg: Sprite2D = $FlagBg

var checked = false

func on_reset() -> void:
	checked = false
	flag_bg.visible = false

func get_outputs(ball: Ball) -> Array[CoordDir]:
	checked = true
	flag_bg.visible = true
	return super.get_outputs(ball)
