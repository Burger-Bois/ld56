class_name Player extends CharacterBody2D


@export var turn_speed := 0.25

@onready var _left_boot := $LeftBoot as Boot
@onready var _right_boot := $RightBoot as Boot

var _current_pivot: Node2D


func _ready():
	_current_pivot = _left_boot


func _process(delta):
	if Input.is_action_pressed("left"):
		if _right_boot.state == Boot.State.IDLE:
			_right_boot.state = Boot.State.LIFTING
	elif Input.is_action_just_released("left"):
		if _right_boot.state == Boot.State.LIFTED:
			_right_boot.state = Boot.State.STOMPING
		else:
			_right_boot.state = Boot.State.LOWERING

	if Input.is_action_pressed("right"):
		if _left_boot.state == Boot.State.IDLE:
			_left_boot.state = Boot.State.LIFTING
	elif Input.is_action_just_released("right"):
		if _left_boot.state == Boot.State.LIFTED:
			_left_boot.state = Boot.State.STOMPING
		else:
			_left_boot.state = Boot.State.LOWERING
	
	var turn_direction := 0.0
	if _right_boot.is_pivot() and not _left_boot.is_pivot():
		_current_pivot = _right_boot
		turn_direction += 1
	elif _left_boot.is_pivot() and not _right_boot.is_pivot():
		_current_pivot = _left_boot
		turn_direction += -1
	
	var direction_y := 0.0
	if Input.is_action_pressed("forward"):
		direction_y += 1
	if Input.is_action_pressed("backward"):
		direction_y += -1
	
	rotate_around_point(
		_current_pivot.position.rotated(rotation),
		turn_direction * direction_y * turn_speed * TAU * delta)


func rotate_around_point(point: Vector2, rot: float):
	var position_delta := -point.rotated(rot) + point
	rotation += rot
	position += position_delta
