class_name FlagGate
extends GateHex

@onready var flag_bg: Sprite2D = $FlagBg
@onready var light_off: Sprite2D = $Light

var checked = false

func on_reset() -> void:
	checked = false
	flag_bg.visible = false
	light_off.visible = true

func get_outputs(ball: Ball) -> Array[CoordDir]:
	checked = true
	flag_bg.visible = true
	light_off.visible = false
	return super.get_outputs(ball)
