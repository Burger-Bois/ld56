extends Enemy

func _physics_process(delta: float) -> void:
	velocity = Vector2.RIGHT.rotated(direction) * speed
	move_and_slide()
