class_name LevelData
extends Resource

@export var fixed_tiles: Array[HexData]

# Type of gate and the number the player can place
@export var placeable: Dictionary[Global.GATE_TYPE, int]
