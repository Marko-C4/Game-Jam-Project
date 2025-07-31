class_name Gates
extends Node2D

@onready var hex_tile: HexTile = $".."

@onready var start_gate: GateHex = $StartGate
@onready var arrow_gate: GateHex = $ArrowGate

@onready var GATE_TYPE_MAP := {
	Global.GATE_TYPE.START_GATE: start_gate,
	Global.GATE_TYPE.ARROW_GATE: arrow_gate,
}

var gate: GateHex

func _ready() -> void:
	for gate: GateHex in GATE_TYPE_MAP.values():
		gate.visible = false

func set_gate(type: Global.GATE_TYPE) -> void:
	gate = GATE_TYPE_MAP[type]
	gate.hex_tile = hex_tile
	gate.visible = true

func get_outputs(input_dir: Utils.Direction) -> Array[CoordDir]:
	return gate.get_outputs(input_dir)

func update_direction() -> void:
	global_rotation = Utils.rotations[hex_tile.direction]
