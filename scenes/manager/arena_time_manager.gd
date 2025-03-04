extends Node

signal arena_difficulty_increased(arena_difficulty: int)
signal boss_spawned

const DIFFICULTY_INTERVAL = 5

@export var end_screen_scene: PackedScene
@onready var timer = $Timer

var arena_difficulty = 0
var elapsed_time = 0  
var boss_already_spawned = false 

func _ready():
	set_timer_for_level()
	timer.timeout.connect(on_timer_timeout)
	timer.start()  

func set_timer_for_level():
	if GlobalState.selected_level == "main":  
		timer.wait_time = 240
	elif GlobalState.selected_level == "main2":  
		timer.wait_time = 300  
	elif GlobalState.selected_level == "main3":  
		timer.wait_time = 120  
	else:
		print("ArenaTimeManager: Warning - Unrecognized level, using default timer.")

	timer.stop()
	timer.start()

func _process(delta):
	elapsed_time += delta

	var next_time_target = (arena_difficulty + 1) * DIFFICULTY_INTERVAL
	if elapsed_time >= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)

	if elapsed_time >= timer.wait_time and not boss_already_spawned:
		boss_already_spawned = true
		print("Boss should spawn now")  
		spawn_boss()

func get_time_elapsed():
	return elapsed_time 

func on_timer_timeout():
	print("ArenaTimeManager: Timer reached limit but continues running.")

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
	print("Boss defeated, triggering victory screen.")

	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.play_jingle()
	MetaProgression.save()
