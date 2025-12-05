extends Node

signal arena_difficulty_increased(arena_difficulty: int)
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
	timer.wait_time = GlobalState.get_level_timer()
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
	pass


func spawn_boss():
	var boss_scene = preload("res://scenes/game_object/boss_enemy/boss_enemy.tscn")
	var boss_instance = boss_scene.instantiate()

	var entities_layer = get_tree().get_first_node_in_group(Constants.GROUP_ENTITIES_LAYER)
	entities_layer.add_child(boss_instance)

	boss_instance.global_position = Vector2(400, 300)
	boss_instance.scale = Vector2(2, 2)

	boss_instance.died.connect(on_boss_defeated)


func on_boss_defeated():
	
	MetaProgression.complete_level(GlobalState.selected_level)

	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.play_jingle()
	MetaProgression.save()
