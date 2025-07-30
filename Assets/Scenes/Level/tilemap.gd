class_name HexMap
extends Node2D

@onready var terrain: TileMapLayer = $Terrain

var gates: Dictionary[Vector2i, HexTile] = {}

func add_gate(gate: HexTile, coordinate: Vector2i) -> void:
	gates[coordinate] = gate
	gate.position = terrain.map_to_local(coordinate)

func try_get_gate(coordinate: Vector2i) -> HexTile:
	if not gates.has(coordinate):
		return null
	return gates[coordinate]
