extends Area2D

const SPEED = 40
const DAMAGE = 0.3
const SLOW_DURATION = 1
const SLOW_PERCENT = 0.2

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
			
			apply_slow(player)
			queue_free()


func apply_slow(player: Node2D):
	var velocity_component = player.get_node_or_null("VelocityComponent")
	if velocity_component == null:
		return
	
	var existing_timer = player.get_node_or_null("WebSlowTimer")
	if existing_timer:
		existing_timer.start(SLOW_DURATION)
	else:
		var base_speed = player.base_speed
		var slow_amount = int(base_speed * SLOW_PERCENT)
		velocity_component.max_speed -= slow_amount
		
		var timer = Timer.new()
		timer.name = "WebSlowTimer"
		timer.wait_time = SLOW_DURATION
		timer.one_shot = true
		player.add_child(timer)
		timer.timeout.connect(func():
			if is_instance_valid(velocity_component):
				velocity_component.max_speed += slow_amount
			timer.queue_free()
		)
		timer.start()


func set_direction(dir: Vector2):
	direction = dir.normalized()
	rotation = direction.angle()
