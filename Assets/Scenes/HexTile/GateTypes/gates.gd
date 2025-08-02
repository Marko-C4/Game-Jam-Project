class_name Gates
extends Node2D

@onready var hex_tile: HexTile = $".."

@onready var empty_gate: EmptyGate = $EmptyGate
@onready var start_gate: GateHex = $StartGate
@onready var arrow_gate: GateHex = $ArrowGate
@onready var split_gate: SplitGate = $SplitGate
@onready var teleport_gate: TeleportGate = $TeleportGate
@onready var flag_gate: FlagGate = $FlagGate
@onready var bouncy_gate: BouncyGate = $BouncyGate
@onready var ground_gate: GroundGate = $GroundGate
@onready var belt_gate: BeltGate = $BeltGate
@onready var turn_gate: TurnGate = $TurnGate

@onready var GATE_TYPE_MAP := {
	Global.GATE_TYPE.START_GATE: start_gate,
	Global.GATE_TYPE.ARROW_GATE: arrow_gate,
	Global.GATE_TYPE.SPLIT_GATE: split_gate,
	Global.GATE_TYPE.TELEPORT_GATE: teleport_gate,
	Global.GATE_TYPE.FLAG_GATE: flag_gate,
	Global.GATE_TYPE.BOUNCY_GATE: bouncy_gate,
	Global.GATE_TYPE.EMPTY_GATE: empty_gate,
	Global.GATE_TYPE.GROUND_GATE: ground_gate,
	Global.GATE_TYPE.BELT_GATE: belt_gate,
	Global.GATE_TYPE.TURN_GATE: turn_gate,
}

var gate: GateHex

func _ready() -> void:
	for gate: GateHex in GATE_TYPE_MAP.values():
		gate.visible = false
	
	SignalBus.simulation.end.connect(_on_simulation_end)

func set_gate(type: Global.GATE_TYPE) -> void:
	gate = GATE_TYPE_MAP[type]
	gate.hex_tile = hex_tile
	gate.visible = true
	gate.on_place()

func get_outputs(ball: Ball) -> Array[CoordDir]:
	return gate.get_outputs(ball)

func update_direction() -> void:
	gate.set_hex_rotation(hex_tile.direction)
	
func _on_tree_exited() -> void:
	gate.on_remove()

func _on_simulation_end() -> void:
	gate.on_reset()
