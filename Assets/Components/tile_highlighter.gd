class_name TileHighlighter
extends Node

@export var enabled := true : set = _set_enabled
@export var hex_map: HexMap
@export var highlight_layer: TileMapLayer
@export var tile: Vector2i
@export var atlas_id: int

func _process(_delta: float) -> void:
	if not enabled:
		return

	var selected_tile := hex_map.get_hovered_tile()

	if not hex_map.is_travesible(selected_tile):
		highlight_layer.clear()
		return

	_update_tile(selected_tile)

func _set_enabled(new_value: bool) -> void:
	enabled = new_value

	if not enabled and highlight_layer:
		highlight_layer.clear()

func _update_tile(selected_tile: Vector2i) -> void:
	highlight_layer.clear()
	highlight_layer.set_cell(selected_tile, atlas_id, tile)
