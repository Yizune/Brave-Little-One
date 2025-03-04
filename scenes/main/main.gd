extends Node

@export var end_screen_scene: PackedScene

var pause_menu_scene = preload("res://scenes/ui/pause_menu.tscn")

func _ready():
	call_deferred("setup_game")

func setup_game():
	print("Main.gd: Current selected level:", GlobalState.selected_level)

	var time_manager = get_node_or_null("%ArenaTimeManager")
	if time_manager:
		time_manager.set_timer_for_level()
	else:
		print("Warning: ArenaTimeManager not found!")

	connect_player_signals()

func connect_player_signals():
	var player = get_node_or_null("%Player")
	if player and player.health_component:
		print("Main.gd: Player found, connecting health component")
		player.health_component.died.connect(on_player_died)
		print("Main.gd: Connected 'died' signal to on_player_died")
	else:
		print("Error: Player or health_component is null")

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()

func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
	MetaProgression.save()
