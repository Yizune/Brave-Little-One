extends Node

@export var end_screen_scene: PackedScene

var pause_menu_scene = preload("res://scenes/ui/pause_menu.tscn")


func _ready():
	var player = get_node_or_null("%Player")
	if player and player.health_component:
		player.health_component.died.connect(on_player_died)
	else:
		print("Error: Player or health_component is null! Is the Player in the scene?")



func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()


func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
	MetaProgression.save()
