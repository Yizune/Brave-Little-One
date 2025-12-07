extends CharacterBody2D

var projectile_scene = preload("res://scenes/game_object/wizard_enemy/wizard_projectile.tscn")

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var animation_player = $AnimationPlayer

var can_shoot = true
const SHOOT_COOLDOWN = 4
const ATTACK_RANGE = 150.0


func _ready():
	$HurtboxComponent.hit.connect(on_hit)


func _process(delta):
	var player = get_tree().get_first_node_in_group(Constants.GROUP_PLAYER) as Node2D
	if player == null:
		return
	
	var direction_to_player = (player.global_position - global_position).normalized()
	var distance_to_player = global_position.distance_to(player.global_position)
	var move_sign = sign(direction_to_player.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)
	
	if distance_to_player <= ATTACK_RANGE:
		velocity_component.velocity = Vector2.ZERO
		set_is_moving(false)
		if can_shoot:
			fire_projectile()
	else:
		velocity_component.accelerate_in_direction(direction_to_player)
		set_is_moving(true)
	
	velocity_component.move(self)


func set_is_moving(moving: bool):
	if moving:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")


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
