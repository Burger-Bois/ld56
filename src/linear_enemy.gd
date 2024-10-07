extends Enemy

func _physics_process(delta: float) -> void:
	if _is_pushed:
		velocity = _push_direction * BLAST_SPEED
	else:
		velocity = Vector2.RIGHT.rotated(direction) * speed
	move_and_slide()


func _on_blast_timer_timeout() -> void:
	_is_pushed = false # Replace with function body.
