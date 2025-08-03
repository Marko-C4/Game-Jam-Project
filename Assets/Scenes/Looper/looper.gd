class_name Looper
extends Node2D

@onready var line_2d: Line2D = $Line2D
@export var MAX_LENGTH = 10

var queue: Array[Vector2]

func _process(delta: float) -> void:
	var pos = get_global_mouse_position()
	queue.push_front(pos)
	
	if queue.size() > MAX_LENGTH:
		queue.pop_back()
	
	line_2d.clear_points()
	
	for point in queue:
		line_2d.add_point(point)
