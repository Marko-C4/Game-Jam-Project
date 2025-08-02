class_name HexButton
extends Button

const MY_SCENE = preload("res://Assets/Scenes/UI/GateUI/HexButton/hex_button.tscn")

@onready var name_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/Name
@onready var count_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/Count

@onready var icon_texture: TextureRect = $MarginContainer/HBoxContainer/Outline/Icon

var count: int : set = _set_count

static func create_instance(parent: Node, type: Global.GATE_TYPE, count: int) -> HexButton:
	var instance = MY_SCENE.instantiate()
	instance.count = count
	parent.add_child(instance)
	instance.name_label.text = Global.GATE_TO_NAME[type]
	instance.count_label.text = str(count)
	instance.icon_texture.texture.region.position = Global.GATE_TO_ATLAS[type] * Vector2(Global.GATE_ATLAS_X_OFFSET, Global.GATE_ATLAS_Y_OFFSET)
	return instance
	
func _ready() -> void:
	SignalBus.simulation.start.connect(
		func():
			disabled = true
	)
	SignalBus.simulation.end.connect(
		func():
			disabled = false
	)

func _set_count(value: int) -> void:
	count = value
	visible = value > 0
	if is_node_ready():
		count_label.text = str(count)
