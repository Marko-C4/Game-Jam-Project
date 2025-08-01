# class_name Global
extends Node

enum GATE_TYPE {
	START_GATE,
	ARROW_GATE,
	SPLIT_GATE,
}

var GATE_TO_NAME = {
	GATE_TYPE.START_GATE: 'Start Gate',
	GATE_TYPE.ARROW_GATE: 'Arrow Gate',
	GATE_TYPE.SPLIT_GATE: 'Split Gate',
}

var LEVELS: Dictionary[String, PackedScene] = {
	TEST1 = preload("res://Assets/Scenes/Stage/test_stage_1.tscn"),
	TEST2 = preload("res://Assets/Scenes/Stage/test_stage_2.tscn"),
}
