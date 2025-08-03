class_name TeleportGate
extends GateHex

var pair: TeleportGate = null
var pair_id = -1
static var global_id_count = 0

@onready var sprite_2d: Sprite2D = $Sprite2D

var tween = Tween.new()

const color_map = [
	Color.CYAN, Color.GREEN, Color.DEEP_PINK,
	Color.GOLD, Color.BEIGE, Color.MEDIUM_PURPLE,
	Color.RED, Color.DARK_BLUE,	Color.DIM_GRAY
]

func on_place() -> void:
	var found_pair = false
	for teleport: TeleportGate in get_tree().get_nodes_in_group("teleport_gate"):
		if teleport.visible and not teleport.is_queued_for_deletion() and not teleport.pair and teleport != self and not found_pair:
			teleport.pair = self
			pair = teleport
			found_pair = true

	if found_pair:
		if pair.pair_id == -1:
			pair.pair_id = global_id_count
			global_id_count += 1
		pair_id = pair.pair_id

		pair_animations(pair)
		pair_animations(self)
		

func pair_animations(gate: TeleportGate):
	var color = color_map[pair_id % color_map.size()]
	gate.tween = create_tween()
	gate.tween.tween_property(gate.sprite_2d, 'modulate', color, 1)

	gate.tween.set_loops()
	gate.tween.tween_property(gate.sprite_2d, "scale", Vector2(1.1, 1.1), 2)
	gate.tween.tween_property(gate.sprite_2d, "scale", Vector2(0.9, 0.9), 2)

func on_remove() -> void:
	if pair:
		if tween:
			tween.kill()
		if pair.tween:
			pair.tween.kill()
		pair.pair = null
		pair = null

func get_outputs(ball: Ball) -> Array[CoordDir]:
	if pair:
		ball._path.append(pair.hex_tile.coordinate)
		ball._path.append(pair.hex_tile.coordinate + ball._head_dir)
		ball.special_movement[ball._path_index] = hex_tile.gate_type
		return [ CoordDir.new(pair.hex_tile.coordinate, -1) ]


	return []
