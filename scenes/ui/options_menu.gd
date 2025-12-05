extends CanvasLayer

signal back_pressed

const WINDOWED_TEXT = "Windowed"
const FULLSCREEN_TEXT = "Fullscreen"

@onready var window_button: Button = $%WindowButton
@onready var sfx_slider: HSlider = %SfxSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var back_button: Button = $%BackButton


func _ready():
	var background = get_node_or_null("Background")
	if background:
		background.size = get_viewport().get_visible_rect().size
		get_tree().root.size_changed.connect(_on_viewport_resized)
	
	back_button.pressed.connect(on_back_pressed)
	window_button.pressed.connect(on_window_button_pressed)
	sfx_slider.value_changed.connect(on_sfx_slider_changed)
	music_slider.value_changed.connect(on_music_slider_changed)
	update_display()


func update_display():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = FULLSCREEN_TEXT
	else:
		window_button.text = WINDOWED_TEXT
	sfx_slider.value = MetaProgression.save_data[Constants.SAVE_KEY_SFX_VOLUME]
	music_slider.value = MetaProgression.save_data[Constants.SAVE_KEY_MUSIC_VOLUME]


func on_window_button_pressed():
	var is_fullscreen = DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN
	MetaProgression.set_fullscreen(is_fullscreen)
	update_display()


func on_sfx_slider_changed(value: float):
	MetaProgression.set_sfx_volume(value)


func on_music_slider_changed(value: float):
	MetaProgression.set_music_volume(value)


func on_back_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	back_pressed.emit()


func _on_viewport_resized():
	var background = get_node_or_null("Background")
	if background:
		background.size = get_viewport().get_visible_rect().size
