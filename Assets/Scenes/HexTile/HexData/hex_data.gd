class_name HexData
extends Resource

@export var coordinate: Vector2i
@export var direction: Utils.Direction
@export var scene: PackedScene

func create_instance(parent: Node) -> HexTile:
	var instance = scene.instantiate() as HexTile
	instance.direction = direction
	parent.add_child(instance)
	return instance
