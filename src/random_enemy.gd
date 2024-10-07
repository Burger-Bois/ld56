extends Enemy

func _ready() -> void:
	speed = 80
	damage = 15

func _physics_process(delta: float) -> void:
	if _is_pushed:
		velocity = _push_direction * BLAST_SPEED
	else:
		velocity = Vector2.RIGHT.rotated(direction) * speed
	move_and_slide()

func _on_change_direction_timer_timeout() -> void:
	direction += randf_range(-PI / 4, PI / 4)


func _on_blast_timer_timeout() -> void:
	_is_pushed = false
