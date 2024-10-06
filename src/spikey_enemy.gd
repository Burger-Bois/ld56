extends Enemy

func _ready() -> void:
	speed = 90
	damage = 10
	health_bonus = -15

func _physics_process(delta: float) -> void:
	velocity = Vector2.RIGHT.rotated(direction) * speed
	move_and_slide()

func _on_change_direction_timer_timeout() -> void:
		direction += randf_range(-PI / 4, PI / 4)
