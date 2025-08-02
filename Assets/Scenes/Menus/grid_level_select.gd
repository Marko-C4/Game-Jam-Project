extends Control

const WORLD_NAMES = [
		"Limbo", 
		"Lust", 
		"Gluttony", 
		"Greed", 
		"Anger", 
		"Heresy", 
		"Violence", 
		"Fraud", 
		"Treachery"
	]
	

var common_level_scene = load("res://Assets/Scenes/Levels/level_1.tscn")

func _ready():
	for i in Levels.WORLDS.size():
		var world_box = VBoxContainer.new()
		
		var label = Label.new()
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.text = WORLD_NAMES[i]
		world_box.add_child(label)
		
		var grid = GridContainer.new()
		grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		grid.columns = 5
		world_box.add_child(grid)
		
		for j in Levels.WORLDS[i].size():
			var stage_scene: PackedScene = Levels.get_stage(i, j)
			var button = Button.new()
			button.text = "Stage %d" % (j + 1)
			button.connect("pressed", _on_stage_button_pressed.bind(i, j))
			button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			grid.add_child(button)
		
		var panel = PanelContainer.new()
		panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var base_color = Color(1, 0.6, 0.6, 1)  
		
		var max_levels = Levels.WORLDS[i].size()
		
		var darken_factor = lerp(0.8, 0.5, float(max_levels - 1) / max_levels)
		var final_color = base_color * darken_factor
		final_color.a = 1 
		
		var style = StyleBoxFlat.new()
		style.bg_color = final_color
		
		panel.add_theme_stylebox_override("panel", style)
		panel.add_child(world_box)
		$VBoxContainer.add_child(panel)


func _on_stage_button_pressed(world: int, stage: int):
	var common_level_scene_instance = common_level_scene.instantiate()
	get_tree().root.add_child(common_level_scene_instance)
	common_level_scene_instance._load_level(Levels.get_stage(world, stage));
	hide()
	print("test")
