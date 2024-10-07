class_name Centimantis extends Enemy


signal stomped

@export var flee_speed := 200
@export var max_speed := 200
@export var acceleration := 100

@export var follow_target: Node2D

enum State {CHASING, FLEEING}
var _state := State.CHASING


func _physics_process(delta):
	if _state == State.CHASING:
		var _target_direction = global_position.direction_to(follow_target.global_position)
		velocity += _target_direction * acceleration * delta
		velocity = velocity.limit_length(max_speed)
		rotation = velocity.angle()
		move_and_slide()
	elif _state == State.FLEEING:
		var _target_direction := global_position.direction_to(follow_target.global_position)
		velocity = -_target_direction * flee_speed
		move_and_slide()


func hit():
	stomped.emit()


func remove():
	pass
