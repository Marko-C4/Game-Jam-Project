# class_name Utils
extends Node

enum Direction {
	TOP_RIGHT,
	MID_RIGHT,
	BOT_RIGHT,
	BOT_LEFT,
	MID_LEFT,
	TOP_LEFT,
}

var rotations := {
	Utils.Direction.TOP_RIGHT: 0,
	Utils.Direction.MID_RIGHT: deg_to_rad(60),
	Utils.Direction.BOT_RIGHT: deg_to_rad(120),
	Utils.Direction.BOT_LEFT: deg_to_rad(180),
	Utils.Direction.MID_LEFT: deg_to_rad(240),
	Utils.Direction.TOP_LEFT: deg_to_rad(300),
}
