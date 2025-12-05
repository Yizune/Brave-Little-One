extends Area2D

const SPEED = 50
const DAMAGE = 0.5

var direction: Vector2 = Vector2.ZERO
var has_hit = false


func _ready():
	await get_tree().create_timer(5.0).timeout
	queue_free()


func _process(delta):
	if has_hit:
		return
		
	global_position += direction * SPEED * delta
	
	var player = get_tree().get_first_node_in_group(Constants.GROUP_PLAYER) as Node2D
	if player:
		var distance = global_position.distance_to(player.global_position)
		if distance < 12:
			has_hit = true
			var health_component = player.get_node_or_null("HealthComponent")
			if health_component:
				health_component.damage(DAMAGE, true)
			queue_free()


func set_direction(dir: Vector2):
	direction = dir.normalized()
	rotation = direction.angle()
