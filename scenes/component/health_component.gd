extends Node
class_name HealthComponent

signal died
signal health_changed
signal health_decreased

@export var max_health: float = 10.0

var current_health: float


func _ready():
	current_health = max_health


func damage(damage_amount: float, apply_resistance: bool = false):
	var final_damage = damage_amount
	if apply_resistance:
		var resistance = MetaProgression.get_damage_resistance()
		final_damage = damage_amount * (1.0 - resistance)
	current_health = clamp(current_health - final_damage, 0, max_health)
	health_changed.emit()
	if damage_amount > 0:
		health_decreased.emit()
	Callable(check_death).call_deferred()


func heal(heal_amount: float):
	damage(-heal_amount)


func get_health_percent() -> float:
	if max_health <= 0:
		return 0.0
	return minf(current_health / max_health, 1.0)


func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()
