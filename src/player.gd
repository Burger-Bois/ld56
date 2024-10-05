class_name Player extends CharacterBody2D


@export var turn_speed := 0.25

@onready var _left_pivot := %LeftPivot as Marker2D
@onready var _right_pivot := %RightPivot as Marker2D

var _left_lifted := false
var _right_lifted := false

var _current_pivot_point: Vector2
var _turn_direction_clockwise: bool


func _process(delta):
	if Input.is_action_pressed("left"):
		_right_lifted = true
		_left_lifted = false
		_current_pivot_point = _left_pivot.position.rotated(rotation)
		_turn_direction_clockwise = true
	elif Input.is_action_pressed("right"):
		_right_lifted = false
		_left_lifted = true
		_current_pivot_point = _right_pivot.position.rotated(rotation)
		_turn_direction_clockwise = false
	else:
		_right_lifted = false
		_left_lifted = false
	
	var direction_y := 0.0
	if Input.is_action_pressed("forward"):
		direction_y += 1
	if Input.is_action_pressed("backward"):
		direction_y += -1
	
	if direction_y != 0 and (_right_lifted or _left_lifted):
		if _turn_direction_clockwise:
			rotate_around_point(_current_pivot_point, -direction_y * turn_speed * TAU * delta)
		else:
			rotate_around_point(_current_pivot_point, direction_y * turn_speed * TAU * delta)


func rotate_around_point(point: Vector2, rot: float):
	var position_delta := -point.rotated(rot) + point
	rotation += rot
	position += position_delta
