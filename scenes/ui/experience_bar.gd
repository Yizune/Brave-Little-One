extends CanvasLayer

@export var experience_manager: Node
@onready var progress_bar = $MarginContainer/ProgressBar

func _ready():
	progress_bar.value = 0
	if experience_manager:
		experience_manager.experience_updated.connect(on_experience_updated)
	else:
		print("Error: experience_manager is null! Did you assign it in the inspector?")
	

func on_experience_updated(current_experience: float, target_experience: float):
	var percent = current_experience / target_experience
	progress_bar.value = percent
