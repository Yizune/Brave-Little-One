extends Node

@export var end_screen_scene: PackedScene

var pause_menu_scene = preload("res://scenes/ui/pause_menu.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	call_deferred("setup_game")

func setup_game():
	var time_manager = get_node_or_null("%ArenaTimeManager")
	if time_manager:
		time_manager.set_timer_for_level()
	connect_player_signals()


func connect_player_signals():
	var player = get_node_or_null("%Player")
	if player and player.health_component:
		player.health_component.died.connect(on_player_died)

func _unhandled_input(event):
	if event.is_action_pressed(Constants.ACTION_PAUSE):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()

func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
	MetaProgression.save()
