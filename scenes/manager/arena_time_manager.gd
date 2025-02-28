extends Node

signal arena_difficulty_increased(arena_difficulty: int)
signal boss_spawned

const DIFFICULTY_INTERVAL = 5

@export var end_screen_scene: PackedScene

@onready var timer = $Timer

var arena_difficulty = 0

func _ready():
	timer.timeout.connect(on_timer_timeout)

func _process(delta):
	var next_time_target = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
	if timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)

func get_time_elapsed():
	return timer.wait_time - timer.time_left

func on_timer_timeout():
	spawn_boss()

func spawn_boss():
	var boss_scene = preload("res://scenes/game_object/boss_enemy/boss_enemy.tscn")
	var boss_instance = boss_scene.instantiate()

	print("Boss instance type: ", boss_instance)

	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(boss_instance)

	boss_instance.global_position = Vector2(400, 300)
	boss_instance.scale = Vector2(2, 2)


	boss_instance.died.connect(on_boss_defeated)
	print("Connected boss 'died' signal to on_boss_defeated.")  
	print(boss_instance.get_signal_connection_list("died"))

func on_boss_defeated():
	print("Boss defeated! Triggering victory screen.")

	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.play_jingle()
	MetaProgression.save()
