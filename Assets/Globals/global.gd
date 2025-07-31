# class_name Global
extends Node

enum GATE_TYPE {
	START_GATE,
	ARROW_GATE
}

var GATE_TO_NAME = {
	GATE_TYPE.START_GATE: 'Start Gate',
	GATE_TYPE.ARROW_GATE: 'Arrow Gate'
}
