extends CanvasLayer

var options_scene = preload("res://scenes/ui/options_menu.tscn")


func _ready():
	var background = get_node_or_null("Background")
	if background:
		background.size = get_viewport().get_visible_rect().size
		get_tree().root.size_changed.connect(_on_viewport_resized)
	
	connect_button("%PlayButton", on_play_pressed)
	connect_button("%UpgradesButton", on_upgrades_pressed)
	connect_button("%OptionsButton", on_options_pressed)
	connect_button("%QuitButton", on_quit_pressed)


func connect_button(node_path: String, callback: Callable):
	var button = get_node_or_null(node_path)
	if button:
		button.pressed.connect(callback)


func on_play_pressed():
	transition_to_scene(Constants.SCENE_LEVEL_SELECTOR)


func on_upgrades_pressed():
	transition_to_scene(Constants.SCENE_META_MENU)


func on_options_pressed():
	transition_to_scene_with_instance(options_scene, on_options_closed)


func on_quit_pressed():
	get_tree().quit()


func on_options_closed(options_instance: Node):
	options_instance.queue_free()


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


func _on_viewport_resized():
	var background = get_node_or_null("Background")
	if background:
		background.size = get_viewport().get_visible_rect().size
