extends CharacterBody2D

signal died

@onready var health_component: HealthComponent = $HealthComponent
@onready var velocity_component = $VelocityComponent
@onready var visuals = $Visuals
@onready var health_bar: ProgressBar = $BossHealthBar
@onready var health_label: Label = $BossHealthBar/HealthLabel
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent

var is_moving: bool = false


func _ready():
	health_component.health_changed.connect(update_health_bar)
	health_component.died.connect(on_died)
	update_health_bar()


func _process(_delta: float):
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()

	velocity_component.move(self)

	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func set_is_moving(moving: bool):
	is_moving = moving


func update_health_bar():
	var percent = health_component.get_health_percent()
	health_bar.value = percent
	health_label.text = "%d%%" % int(percent * 100)


func on_died():
	died.emit()
