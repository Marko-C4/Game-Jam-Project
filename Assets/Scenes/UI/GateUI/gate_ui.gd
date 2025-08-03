class_name GateUI
extends Control

@onready var button_container: VBoxContainer = %ButtonContainer

signal gate_clicked(type: Global.GATE_TYPE)

var type_to_button: Dictionary[Global.GATE_TYPE, HexButton] = {}

func update_ui(holding_data: Dictionary[Global.GATE_TYPE, int]) -> void:
	for child in button_container.get_children():
		child.queue_free()
	
	for gate_type in holding_data.keys():
		var count = holding_data[gate_type]
		var button = HexButton.create_instance(button_container, gate_type, count)
		type_to_button[gate_type] = button
		button.gui_input.connect(_on_hex_button_pressed.bind(button, gate_type))
 
func take_gate(type: Global.GATE_TYPE) -> void:
	type_to_button[type].count -= 1

func return_gate(type: Global.GATE_TYPE) -> void:
	type_to_button[type].count += 1

func _on_hex_button_pressed(event: InputEvent, node: Button, type: Global.GATE_TYPE):
	if event.is_action_pressed('mouse1') and not node.disabled:
		gate_clicked.emit(type)
