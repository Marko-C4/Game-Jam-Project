class_name HexData
extends Resource


@export var coordinate: Vector2i
@export var direction: Utils.Direction
@export var gate: Global.GATE_TYPE

static var HEX_TILE = preload("res://Assets/Scenes/HexTile/hex_tile.tscn")

func create_instance(parent: Node) -> HexTile:
	var instance = HEX_TILE.instantiate() as HexTile
	instance.initialize(gate, direction)
	parent.add_child(instance)
	return instance

static func create_instance_from_type(parent: Node, type: Global.GATE_TYPE) -> HexTile:
	var instance = HEX_TILE.instantiate() as HexTile
	instance.initialize(type, Utils.Direction.TOP_RIGHT)
	parent.add_child(instance)
	return instance
