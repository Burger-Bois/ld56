class_name FollowingEnemy extends Enemy

var _player: Player

func _ready() -> void:
	speed = 100
	damage = 4
	health_bonus = 3

func _physics_process(delta: float) -> void:
	var distance_to_player = global_position.distance_to(_player.global_position)
	if _is_pushed:
		velocity = _push_direction * BLAST_SPEED
	else:
		if distance_to_player > 0 && distance_to_player < 50 :
			direction += randf_range(-PI / 4, PI / 4)
			velocity = Vector2.RIGHT.rotated(direction) * speed
		else: 
			velocity = global_position.direction_to(_player.global_position) * speed
			look_at(_player.global_position)
	move_and_slide()


func _on_blast_timer_timeout() -> void:
	_is_pushed = false
