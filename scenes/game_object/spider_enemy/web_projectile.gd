extends Area2D

const SPEED = 40
const DAMAGE = 0.3
const SLOW_DURATION = 1.0
const SLOW_AMOUNT = 0.8 

var direction: Vector2 = Vector2.ZERO
var has_hit = false


func _ready():
	await get_tree().create_timer(5.0).timeout
	if is_instance_valid(self):
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
			
			var velocity_component = player.get_node_or_null("VelocityComponent")
			if velocity_component:
				var original_speed = velocity_component.max_speed
				velocity_component.max_speed = int(original_speed * SLOW_AMOUNT)
				
				var timer = Timer.new()
				timer.wait_time = SLOW_DURATION
				timer.one_shot = true
				player.add_child(timer)
				timer.timeout.connect(func():
					if is_instance_valid(velocity_component):
						velocity_component.max_speed = original_speed
					timer.queue_free()
				)
				timer.start()
			
			queue_free()


func set_direction(dir: Vector2):
	direction = dir.normalized()
	rotation = direction.angle()
