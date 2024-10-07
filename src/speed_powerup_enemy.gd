class_name SpeedPowerUpEnemy extends Enemy

func _ready() -> void:
	speed = 45
	damage = 0
	health_bonus = 0

func _physics_process(delta: float) -> void:
	velocity = Vector2.RIGHT.rotated(direction) * speed
	move_and_slide()

func _on_change_direction_timer_timeout() -> void:
	direction += randf_range(-PI / 4, PI / 4)
