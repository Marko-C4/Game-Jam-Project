class_name CoordDir
extends RefCounted

var coord: Vector2i
var dir: Utils.Direction

func _init(coord: Vector2i, dir: Utils.Direction) -> void:
	self.coord = coord
	self.dir = dir
