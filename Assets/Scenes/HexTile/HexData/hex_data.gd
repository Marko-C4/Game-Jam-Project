class_name HexData
extends Resource

@export var coordinate: Vector2i
@export var direction: Utils.Direction
@export var gate: Global.GATE_TYPE

const HEX_TILE = preload("res://Assets/Scenes/HexTile/hex_tile.tscn")

func create_instance(parent: Node) -> HexTile:
	var instance = HEX_TILE.instantiate() as HexTile
	instance.initialize(gate, direction)
	parent.add_child(instance)
	return instance
