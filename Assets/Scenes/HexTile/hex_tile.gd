class_name HexTile
extends Node2D

@export var gate_type: Global.GATE_TYPE
@export var direction: Utils.Direction
@onready var dnd: DragAndDrop = $DnD

@onready var gates: Gates = $Gates

var coordinate: Vector2i

func _ready() -> void:
	gates.set_gate(gate_type)
	gates.update_direction()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('rotate') and dnd.dragging:
		direction = posmod(direction + 1, Utils.rotations.size())
		gates.update_direction()

func initialize(gate_type: Global.GATE_TYPE, direction: Utils.Direction):
	self.gate_type = gate_type
	self.direction = direction

func get_gate() -> GateHex:
	return gates.gate
