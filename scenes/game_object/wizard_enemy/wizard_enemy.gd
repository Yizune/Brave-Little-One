extends CharacterBody2D

var projectile_scene = preload("res://scenes/game_object/wizard_enemy/wizard_projectile.tscn")

@onready var velocity_component = $VelocityComponent
@onready var visuals = $Visuals

var is_moving = false
var can_shoot = true
const SHOOT_COOLDOWN = 4.0


func _ready():
	$HurtboxComponent.hit.connect(on_hit)


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
	var was_moving = is_moving
	is_moving = moving
	
	if was_moving and not is_moving:
		fire_projectile()


func fire_projectile():
	if not can_shoot:
		return
	
	var player = get_tree().get_first_node_in_group(Constants.GROUP_PLAYER) as Node2D
	if player == null:
		return
	
	can_shoot = false
	
	var projectile = projectile_scene.instantiate()
	get_tree().get_first_node_in_group(Constants.GROUP_ENTITIES_LAYER).add_child(projectile)
	projectile.global_position = global_position
	
	var direction = (player.global_position - global_position).normalized()
	projectile.set_direction(direction)
	
	await get_tree().create_timer(SHOOT_COOLDOWN).timeout
	can_shoot = true


func on_hit(_damage: float):
	$HitRandomAudioPlayerComponent.play_random()
