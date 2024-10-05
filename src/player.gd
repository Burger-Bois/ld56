class_name Player extends CharacterBody2D


@export var turn_speed := 0.25

@onready var _left_pivot := %LeftPivot as Marker2D
@onready var _right_pivot := %RightPivot as Marker2D

var _left_lifted := false
var _right_lifted := false

var _current_pivot: Node2D


func _ready():
	_current_pivot = _left_pivot


func _process(delta):
	var turn_direction := 0.0
	if Input.is_action_pressed("left"):
		_current_pivot = _left_pivot
		_right_lifted = true
		turn_direction += -1
	else:
		_left_lifted = false

	if Input.is_action_pressed("right"):
		_current_pivot = _right_pivot
		_left_lifted = true
		turn_direction += 1
	else:
		_left_lifted = false
	
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
