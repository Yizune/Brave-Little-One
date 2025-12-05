extends Node

var selected_level: String = ""

var level_config: Dictionary = {
	Constants.LEVEL_PLAINS: { "timer": 120, "max_enemies": 50 },
	Constants.LEVEL_ARENA: { "timer": 240, "max_enemies": 60 },
	Constants.LEVEL_RUINS: { "timer": 300, "max_enemies": 70 }
}


func get_level_config() -> Dictionary:
	return level_config[selected_level]


func get_level_timer() -> int:
	return get_level_config().timer


func get_max_enemies() -> int:
	return get_level_config().max_enemies
