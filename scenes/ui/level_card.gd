extends PanelContainer

signal play_pressed

@onready var name_label: Label = %NameLabel
@onready var stars_container: HBoxContainer = %StarsContainer
@onready var play_button: Button = %PlayButton

var level_data: LevelData
var star_filled_texture: Texture2D = preload("res://assets/ui/full_star.png")
var star_empty_texture: Texture2D = preload("res://assets/ui/empty_star.png")
var is_locked: bool = false


func _ready():
	play_button.pressed.connect(on_play_pressed)


func set_level(data: LevelData, locked: bool = false):
	level_data = data
	is_locked = locked
	name_label.text = data.name
	
	if is_locked:
		play_button.text = "Locked"
		play_button.disabled = true
		modulate = Color(0.6, 0.6, 0.6, 1.0)
	else:
		play_button.text = "Play"
		play_button.disabled = false
		modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	update_stars(data.stars, data.max_stars)


func update_stars(stars_earned: int, max_stars: int):
	for child in stars_container.get_children():
		child.queue_free()
	
	for i in max_stars:
		var star = TextureRect.new()
		star.custom_minimum_size = Vector2(16, 16)
		star.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		star.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		if i < stars_earned:
			star.texture = star_filled_texture
		else:
			star.texture = star_empty_texture
		stars_container.add_child(star)


func on_play_pressed():
	play_pressed.emit()
