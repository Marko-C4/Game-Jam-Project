class_name FlagGate
extends GateHex

var checked = false

func on_reset() -> void:
	checked = false

func get_outputs(ball: Ball) -> Array[CoordDir]:
	checked = true
	return super.get_outputs(ball)
