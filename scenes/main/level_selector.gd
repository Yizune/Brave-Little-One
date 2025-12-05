extends CanvasLayer

@export var levels: Array[LevelData] = []

@onready var levels_container: VBoxContainer = %LevelsVBox

var level_card_scene: PackedScene = preload("res://scenes/ui/level_card.tscn")


func _ready():
	var background = get_node_or_null("Background")
	if background:
		background.size = get_viewport().get_visible_rect().size
		get_tree().root.size_changed.connect(_on_viewport_resized)
	
	for child in levels_container.get_children():
		child.queue_free()
	
	create_level_cards()
	connect_button("%UpgradesButton", on_upgrades_pressed)
	connect_button("%BackButton", on_back_pressed)


func create_level_cards():
	var completed_levels = MetaProgression.save_data.get(Constants.SAVE_KEY_COMPLETED_LEVELS, [])
	
	for i in range(levels.size()):
		var level_data = levels[i]
		var card = level_card_scene.instantiate()
		levels_container.add_child(card)
		
		var is_locked = false
		if i > 0:
			var previous_level_id = levels[i - 1].id
			is_locked = previous_level_id not in completed_levels
		
		card.set_level(level_data, is_locked)
		card.play_pressed.connect(on_level_selected.bind(level_data))


func connect_button(node_path: String, callback: Callable):
	var button = get_node_or_null(node_path)
	if button:
		button.pressed.connect(callback)


func on_level_selected(level_data: LevelData):
	GlobalState.selected_level = level_data.id
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file(level_data.scene_path)


func on_upgrades_pressed():
	transition_to_scene(Constants.SCENE_META_MENU)


func on_back_pressed():
	transition_to_scene(Constants.SCENE_MAIN_MENU)


func transition_to_scene(scene_path: String):
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file(scene_path)


func _on_viewport_resized():
	var background = get_node_or_null("Background")
	if background:
		background.size = get_viewport().get_visible_rect().size
