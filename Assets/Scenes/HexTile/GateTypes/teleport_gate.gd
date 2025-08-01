class_name TeleportGate
extends GateHex

var pair: TeleportGate = null

func on_place() -> void:
	for teleport: TeleportGate in get_tree().get_nodes_in_group("teleport_gate"):
		if teleport.visible and not teleport.pair and teleport != self:
			teleport.pair = self
			pair = teleport

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
