extends CanvasLayer

var options_scene = preload("res://scenes/ui/options_menu.tscn")

func _ready():
	# Connect buttons safely and debug their existence
	connect_button("%PlayButtonArena", on_play_arena)
	connect_button("%PlayButtonDungeon", on_play_dungeon)
	connect_button("%PlayButton", on_play_pressed)
	connect_button("%UpgradesButton", on_upgrades_pressed)
	connect_button("%OptionsButton", on_options_pressed)
	connect_button("%QuitButton", on_quit_pressed)
	connect_button("%BackButton", on_back_button_pressed)

	# Extra Debugging for Dungeon Button
	var dungeon_button = get_node_or_null("%PlayButtonDungeon")
	if dungeon_button:
		dungeon_button.pressed.connect(func(): print("Dungeon button was clicked manually!"))
		print("Dungeon Button found and connected!")
	else:
		print("ERROR: Dungeon Button does not exist in the scene!")

func connect_button(node_path: String, callback: Callable):
	var button = get_node_or_null(node_path)
	if button:
		button.pressed.connect(callback)
		print("Connected button:", node_path)
	else:
		print("Warning: Button not found -", node_path)

func on_play_pressed():
	transition_to_scene("res://scenes/main/level_selector.tscn")

func on_upgrades_pressed():
	transition_to_scene("res://scenes/ui/meta_menu.tscn")

func on_options_pressed():
	transition_to_scene_with_instance(options_scene, on_options_closed)

func on_quit_pressed():
	get_tree().quit()

func on_options_closed(options_instance: Node):
	options_instance.queue_free()

func on_back_button_pressed():
	transition_to_scene("res://scenes/ui/main_menu.tscn")

func on_level_selected(level_path: String):
	transition_to_scene(level_path)

func on_play_arena():
	print("Arena button clicked!")
	on_level_selected("res://scenes/main/main.tscn")  # Load Arena Level

func on_play_dungeon():
	print("Dungeon button clicked!")
	on_level_selected("res://scenes/main/main2.tscn")  # Load Dungeon Level

func transition_to_scene(scene_path: String):
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file(scene_path)

func transition_to_scene_with_instance(scene: PackedScene, callback: Callable):
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	var instance = scene.instantiate()
	add_child(instance)
	instance.back_pressed.connect(callback.bind(instance))





#extends CanvasLayer
#
#var options_scene = preload("res://scenes/ui/options_menu.tscn")
#
#
#func _ready():
	#$%PlayButtonArena.pressed.connect(on_play_arena)
	#$%PlayButtonDungeon.pressed.connect(on_play_dungeon)
	#$%PlayButton.pressed.connect(on_play_pressed)
	#$%UpgradesButton.pressed.connect(on_upgrades_pressed)
	#$%OptionsButton.pressed.connect(on_options_pressed)
	#$%QuitButton.pressed.connect(on_quit_pressed)
	#$%BackButton.pressed.connect(on_back_button_pressed)
	#
#
#func on_play_pressed():
	#ScreenTransition.transition()
	#await ScreenTransition.transitioned_halfway
	##get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	#get_tree().change_scene_to_file("res://scenes/main/level_selector.tscn")
	#
	#
#func on_upgrades_pressed():
	#ScreenTransition.transition()
	#await ScreenTransition.transitioned_halfway
	#get_tree().change_scene_to_file("res://scenes/ui/meta_menu.tscn")
#
#
#func on_options_pressed():
	#ScreenTransition.transition()
	#await ScreenTransition.transitioned_halfway
	#var options_instance = options_scene.instantiate()
	#add_child(options_instance)
	#options_instance.back_pressed.connect(on_options_closed.bind(options_instance))
	#
#
#func on_quit_pressed():
	#get_tree().quit()
#
#
#func on_options_closed(options_instance: Node):
	#options_instance.queue_free()
	#
	#
#
#func on_back_button_pressed():
	#ScreenTransition.transition()
	#await ScreenTransition.transitioned_halfway
	#get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	#
#func on_level_selected(level_path: String):
	#ScreenTransition.transition()
	#await ScreenTransition.transitioned_halfway
	#get_tree().change_scene_to_file(level_path)	
#
#
#func on_play_arena():
	#on_level_selected("res://scenes/main/main.tscn")  # Load Arena Level
#
#func on_play_dungeon():
	#on_level_selected("res://scenes/main/main2.tscn")  # Load Dungeon Level
