class_name TeleportGate
extends GateHex

var pair: TeleportGate = null
var pair_id = -1
static var global_id_count = 0

@onready var sprite_2d: Sprite2D = $Sprite2D

const color_map = [Color.CYAN, Color.RED, Color.GREEN_YELLOW, Color.CORAL]

func on_place() -> void:
	var found_pair = false
	for teleport: TeleportGate in get_tree().get_nodes_in_group("teleport_gate"):
		if teleport.visible and not teleport.pair and teleport != self and not found_pair:
			teleport.pair = self
			pair = teleport
			found_pair = true

	if found_pair:
		if pair.pair_id == -1:
			pair.pair_id = global_id_count
			global_id_count += 1
		pair_id = pair.pair_id
		print(pair_id)

		pair.sprite_2d.modulate = color_map[pair_id % color_map.size()]
		sprite_2d.modulate = color_map[pair_id % color_map.size()]


func on_remove() -> void:
	if pair:
		pair.pair = null
		pair = null

func get_outputs(ball: Ball) -> Array[CoordDir]:
	if pair:
		ball._path.append(pair.hex_tile.coordinate)
		ball._path.append(pair.hex_tile.coordinate + ball._head_dir)
		return [ CoordDir.new(pair.hex_tile.coordinate, -1) ]


	return []
