extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var sprite: Sprite2D = $Visuals/Sprite2D
@onready var hurtbox_component = $HurtboxComponent
@onready var hurtbox_collision = $HurtboxComponent/CollisionShape2D

const VULNERABLE_TIME = 2.0 
const INVINCIBLE_TIME = 2.0 

var is_invincible = false
var vulnerability_timer: float = 0.0
var current_phase_duration: float = VULNERABLE_TIME


func _ready():
	$HurtboxComponent.hit.connect(on_hit)
	is_invincible = false
	current_phase_duration = VULNERABLE_TIME


func _process(delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(-move_sign, 1)
	
	vulnerability_timer += delta
	if vulnerability_timer >= current_phase_duration:
		vulnerability_timer = 0.0
		toggle_invincibility()


func toggle_invincibility():
	is_invincible = !is_invincible
	current_phase_duration = INVINCIBLE_TIME if is_invincible else VULNERABLE_TIME
	
	if hurtbox_collision:
		hurtbox_collision.disabled = is_invincible
	
	if visuals:
		if is_invincible:
			visuals.modulate = Color(0.5, 0.7, 1.0, 0.35)
		else:
			visuals.modulate = Color(1.0, 1.0, 1.0, 1.0)


func on_hit(_damage: float):
	if not is_invincible:
		$HitRandomAudioPlayerComponent.play_random()
