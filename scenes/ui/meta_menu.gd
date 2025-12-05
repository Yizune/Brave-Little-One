extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] = []

@onready var grid_container: GridContainer = $%GridContainer
@onready var back_button: Button = $%BackButton
@onready var loadout_label: Label = $%LoadoutLabel

var meta_upgrade_card_scene: PackedScene = preload("res://scenes/ui/meta_upgrade_card.tscn")


func _ready():
	var background = get_node_or_null("Background")
	if background:
		background.size = get_viewport().get_visible_rect().size
		get_tree().root.size_changed.connect(_on_viewport_resized)
	
	back_button.pressed.connect(on_back_pressed)
	
	for child in grid_container.get_children():
		child.queue_free()

	for upgrade in upgrades:
		var meta_upgrade_card_instance = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(meta_upgrade_card_instance)
		meta_upgrade_card_instance.set_meta_upgrade(upgrade)
	
	update_loadout_label()


func update_loadout_label():
	if loadout_label:
		var loadout_count = MetaProgression.save_data[Constants.SAVE_KEY_ACTIVE_LOADOUT].size()
		loadout_label.text = "Loadout: %d / %d equipped" % [loadout_count, Constants.MAX_LOADOUT_SLOTS]


func on_back_pressed():
	ScreenTransition.transition_to_scene(Constants.SCENE_LEVEL_SELECTOR)


func _on_viewport_resized():
	var background = get_node_or_null("Background")
	if background:
		background.size = get_viewport().get_visible_rect().size
