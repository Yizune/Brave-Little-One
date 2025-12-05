extends Node

var save_data: Dictionary = {
	Constants.SAVE_KEY_META_UPGRADE_CURRENCY: 0,
	Constants.SAVE_KEY_META_UPGRADES: {},
	Constants.SAVE_KEY_SFX_VOLUME: 1.0,
	Constants.SAVE_KEY_MUSIC_VOLUME: 1.0,
	Constants.SAVE_KEY_FULLSCREEN: false,
	Constants.SAVE_KEY_ACTIVE_LOADOUT: [],
	Constants.SAVE_KEY_COMPLETED_LEVELS: []
}


func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_collected)
	load_save_file()
	apply_settings()


func load_save_file():
	if !FileAccess.file_exists(Constants.SAVE_FILE_PATH):
		return
	var file = FileAccess.open(Constants.SAVE_FILE_PATH, FileAccess.READ)
	var loaded_data = file.get_var()
	save_data.merge(loaded_data, true)
	

func save():
	var file = FileAccess.open(Constants.SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)
	

func add_meta_upgrade(upgrade: MetaUpgrade):
	if !save_data[Constants.SAVE_KEY_META_UPGRADES].has(upgrade.id):
		save_data[Constants.SAVE_KEY_META_UPGRADES][upgrade.id] = {
			Constants.SAVE_KEY_QUANTITY: 0
		}
	
	save_data[Constants.SAVE_KEY_META_UPGRADES][upgrade.id][Constants.SAVE_KEY_QUANTITY] += 1
	save()
	
	
func get_upgrade_count(upgrade_id: String) -> int:
	if save_data[Constants.SAVE_KEY_META_UPGRADES].has(upgrade_id):
		return save_data[Constants.SAVE_KEY_META_UPGRADES][upgrade_id][Constants.SAVE_KEY_QUANTITY]
	return 0


func is_upgrade_in_loadout(upgrade_id: String) -> bool:
	return upgrade_id in save_data[Constants.SAVE_KEY_ACTIVE_LOADOUT]


func toggle_loadout_upgrade(upgrade_id: String) -> bool:
	var loadout: Array = save_data[Constants.SAVE_KEY_ACTIVE_LOADOUT]
	
	if upgrade_id in loadout:
		loadout.erase(upgrade_id)
		save()
		return false
	else:
		if loadout.size() < Constants.MAX_LOADOUT_SLOTS:
			loadout.append(upgrade_id)
			save()
			return true
	return false


func get_active_upgrade_count(upgrade_id: String) -> int:
	if is_upgrade_in_loadout(upgrade_id):
		return get_upgrade_count(upgrade_id)
	return 0


func get_damage_multiplier() -> float:
	var level = get_active_upgrade_count(Constants.META_DAMAGE_BOOST)
	return 1.0 + (level * 0.05) 


func get_damage_resistance() -> float:
	var level = get_active_upgrade_count(Constants.META_DAMAGE_RESISTANCE)
	return level * 0.05 


func complete_level(level_id: String):
	var completed_levels = save_data.get(Constants.SAVE_KEY_COMPLETED_LEVELS, [])
	if level_id not in completed_levels:
		completed_levels.append(level_id)
		save_data[Constants.SAVE_KEY_COMPLETED_LEVELS] = completed_levels
		save()


func is_level_completed(level_id: String) -> bool:
	var completed_levels = save_data.get(Constants.SAVE_KEY_COMPLETED_LEVELS, [])
	return level_id in completed_levels
	

func on_experience_collected(number: float):
	save_data[Constants.SAVE_KEY_META_UPGRADE_CURRENCY] += number


func apply_settings():
	var sfx_volume = save_data.get(Constants.SAVE_KEY_SFX_VOLUME, 1.0)
	var music_volume = save_data.get(Constants.SAVE_KEY_MUSIC_VOLUME, 1.0)
	var fullscreen = save_data.get(Constants.SAVE_KEY_FULLSCREEN, false)
	
	var sfx_index = AudioServer.get_bus_index(Constants.SFX)
	var music_index = AudioServer.get_bus_index(Constants.MUSIC)
	AudioServer.set_bus_volume_db(sfx_index, linear_to_db(sfx_volume))
	AudioServer.set_bus_volume_db(music_index, linear_to_db(music_volume))
	
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


func set_sfx_volume(percent: float):
	save_data[Constants.SAVE_KEY_SFX_VOLUME] = percent
	apply_settings()
	save()


func set_music_volume(percent: float):
	save_data[Constants.SAVE_KEY_MUSIC_VOLUME] = percent
	apply_settings()
	save()


func set_fullscreen(enabled: bool):
	save_data[Constants.SAVE_KEY_FULLSCREEN] = enabled
	apply_settings()
	save()
