extends Node

@export var axe_ability_scene: PackedScene

var base_damage = 10
var additional_damage_percent = 1


func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group(Constants.GROUP_PLAYER) as Node2D
	if player == null:
		return
	
	var foreground = get_tree().get_first_node_in_group(Constants.GROUP_FOREGROUND_LAYER) as Node2D
	if foreground == null:
		return
	
	var axe_instance = axe_ability_scene.instantiate() as Node2D
	foreground.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	var meta_damage_mult = MetaProgression.get_damage_multiplier()
	axe_instance.hitbox_component.damage = base_damage * additional_damage_percent * meta_damage_mult


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == Constants.UPGRADE_AXE_DAMAGE:
		additional_damage_percent = 1 + (current_upgrades[Constants.UPGRADE_AXE_DAMAGE][Constants.SAVE_KEY_QUANTITY] * .1)
