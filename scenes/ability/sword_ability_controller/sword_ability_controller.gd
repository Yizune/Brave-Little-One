extends Node

const MAX_RANGE = 150

@export var sword_ability: PackedScene

var base_damage = 5
var additional_damage_percent = 1
var base_wait_time


func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group(Constants.GROUP_PLAYER) as Node2D
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group(Constants.GROUP_ENEMY)
	enemies = enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)

	var sword_instance = sword_ability.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group(Constants.GROUP_FOREGROUND_LAYER)
	foreground_layer.add_child(sword_instance)
	var meta_damage_mult = MetaProgression.get_damage_multiplier()
	sword_instance.hitbox_component.damage = base_damage * additional_damage_percent * meta_damage_mult
	
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == Constants.UPGRADE_SWORD_RATE:
		var percent_reduction = current_upgrades[Constants.UPGRADE_SWORD_RATE][Constants.SAVE_KEY_QUANTITY] * .1
		$Timer.wait_time = base_wait_time * (1 - percent_reduction)
		$Timer.start()
	elif upgrade.id == Constants.UPGRADE_SWORD_DAMAGE:
		additional_damage_percent = 1 + (current_upgrades[Constants.UPGRADE_SWORD_DAMAGE][Constants.SAVE_KEY_QUANTITY] * .15)
