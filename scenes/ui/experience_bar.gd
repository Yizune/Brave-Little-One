extends CanvasLayer

@export var experience_manager: Node

@onready var progress_bar: ProgressBar = $MarginContainer/ProgressBar
@onready var xp_label: Label = $MarginContainer/XPLabel

var current_level: int = 1


func _ready():
	progress_bar.value = 0
	if experience_manager:
		experience_manager.experience_updated.connect(on_experience_updated)
		experience_manager.level_up.connect(on_level_up)
	update_label(0, 1)


func on_experience_updated(current_experience: float, target_experience: float):
	var percent = current_experience / target_experience
	progress_bar.value = percent
	update_label(int(current_experience), int(target_experience))


func on_level_up(new_level: int):
	current_level = new_level


func update_label(current_xp: int, target_xp: int):
	xp_label.text = "Lv. %d: %d / %d" % [current_level, current_xp, target_xp]
