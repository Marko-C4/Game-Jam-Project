class_name HexTile
extends Node2D

@export var gate_type: Global.GATE_TYPE
@export var direction: Utils.Direction

@onready var dnd: DragAndDrop = $DnD
@onready var gates: Gates = $Gates
@onready var hex_bg: Sprite2D = $HexBg

var fixed_in_place = false
var coordinate: Vector2i
var default_z_index: int

func _ready() -> void:
	gates.set_gate(gate_type)
	gates.update_direction()
	default_z_index = z_index
	
	dnd.drag_started.connect(_on_dnd_drag_started)
	dnd.drag_canceled.connect(_on_dnd_drag_canceled)
	dnd.drag_dropped.connect(_on_dnd_drag_dropped)
	
	SignalBus.simulation.start.connect(
		func():
			dnd.enabled = false
	)
	SignalBus.simulation.end.connect(
		func():
			dnd.enabled = !fixed_in_place
	)

func _input(event: InputEvent) -> void:
	if dnd.dragging:
		if event.is_action_pressed('rotate'):
			direction = posmod(direction + 1, Utils.rotations.size())
			gates.update_direction()
		if event.is_action_pressed('rotate_backwards'):
			direction = posmod(direction - 1, Utils.rotations.size())
			gates.update_direction()

func initialize(gate_type: Global.GATE_TYPE, direction: Utils.Direction):
	self.gate_type = gate_type
	self.direction = direction

func get_gate() -> GateHex:
	return gates.gate

func set_fixed() -> void:
	fixed_in_place = true
	hex_bg.modulate = Color(0.314, 0.0, 0.0, 0.2)

func _on_dnd_drag_started() -> void:
	z_index = 100

func _on_dnd_drag_canceled(starting_position: Vector2) -> void:
	z_index = default_z_index

func _on_dnd_drag_dropped(starting_position: Vector2) -> void:
	z_index = default_z_index
