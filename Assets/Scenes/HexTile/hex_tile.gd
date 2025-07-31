class_name HexTile
extends Node2D

@export var gate_type: Global.GATE_TYPE
@export var direction: Utils.Direction

@onready var gates: Gates = $Gates

func _ready() -> void:
	gates.set_gate(gate_type, direction)
	
func initialize(gate_type: Global.GATE_TYPE, direction: Utils.Direction):
	self.gate_type = gate_type
	self.direction = direction

func get_gate() -> GateHex:
	return gates.gate
