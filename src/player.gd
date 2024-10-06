class_name Player extends CharacterBody2D


signal killed

@export var turn_speed := 0.50

@onready var _left_boot := $LeftBoot as Boot
@onready var _right_boot := $RightBoot as Boot

var _current_pivot: Node2D
var _health


func _ready():
	_health = 100
	SignalBus.enemy_hit.connect(on_enemy_hit)
	_current_pivot = _left_boot


func _process(delta):
	if Input.is_action_pressed("left"):
		if _right_boot.state == Boot.State.IDLE and _left_boot.is_pivot():
			_right_boot.state = Boot.State.LIFTING
	elif Input.is_action_just_released("left"):
		if _right_boot.state == Boot.State.LIFTED:
			_right_boot.state = Boot.State.STOMPING
		elif _right_boot.state == Boot.State.LIFTING:
			_right_boot.state = Boot.State.LOWERING
		else:
			_right_boot.state = Boot.State.IDLE

	if Input.is_action_pressed("right"):
		if _left_boot.state == Boot.State.IDLE and _right_boot.is_pivot():
			_left_boot.state = Boot.State.LIFTING
	elif Input.is_action_just_released("right"):
		if _left_boot.state == Boot.State.LIFTED:
			_left_boot.state = Boot.State.STOMPING
		elif _left_boot.state == Boot.State.LIFTING:
			_left_boot.state = Boot.State.LOWERING
		else:
			_left_boot.state = Boot.State.IDLE
	
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
	move_and_collide(position_delta)


func take_damage(enemy: Enemy):
	var new_health = _health - enemy.damage
	set_health(new_health)
	print("health: " + str(_health))
	#kill()
	

func on_enemy_hit(enemy: Enemy):
	var new_health = _health + enemy.health_bonus
	set_health(new_health)
	print("health: " + str(_health))
	
			

func set_health(health: int):
	if health <= 0:
		_health = 0
		kill()
	elif health >= 100:
		_health = 100
	else:
		_health = health

func kill():
	killed.emit()
	hide()
	set.call_deferred("process_mode", ProcessMode.PROCESS_MODE_DISABLED)
