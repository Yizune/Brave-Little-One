extends CharacterBody2D

@onready var health_component = $HealthComponent
@onready var velocity_component = $VelocityComponent
@onready var visuals = $Visuals
@onready var health_bar = $BossHealthBar
@onready var hurtbox_component = $HurtboxComponent

var is_moving = false
var max_health = 1000
var current_health = max_health

signal died 

func _ready():
	hurtbox_component.hit.connect(on_hit)
	update_health_bar()

func _process(delta):
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

func on_hit(damage):
	current_health -= damage
	update_health_bar()
	print("Boss took damage: ", damage, " | Current Health: ", current_health)

	if current_health <= 0:
		print("Boss is dead!")
		emit_signal("died")
		queue_free()

func update_health_bar():
	health_bar.value = float(current_health) / max_health * 100
