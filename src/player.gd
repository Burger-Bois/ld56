class_name Player extends CharacterBody2D


signal killed

@export var turn_speed := 0.50
@export var jump_speed := 100.0

@onready var _left_boot := $LeftBoot as Boot
@onready var _right_boot := $RightBoot as Boot
@onready var _daze_timer := $DazeTimer as Timer
@onready var _invincibility_timer := $InvincibilityTimer as Timer
@onready var _shockwave_animations := $AnimationPlayer as AnimationPlayer

enum State {IDLE, JUMPING, DAZED}

var _current_pivot: Node2D
var _health
var _default_turn_speed
var _default_jump_speed

var _state: State = State.IDLE

var _invincible := false


func _ready():
	_default_turn_speed = turn_speed
	_default_jump_speed = jump_speed
	set_health(100)
	SignalBus.enemy_hit.connect(on_enemy_hit)
	_current_pivot = _left_boot
	# Reset daze bar
	SignalBus.player_dazed_changed.emit(0, _daze_timer.wait_time)


func _process(delta):
	if _state == State.DAZED:
		SignalBus.player_dazed_changed.emit(
			_daze_timer.time_left,
			_daze_timer.wait_time)
	
	if _state == State.IDLE and Input.is_action_just_pressed("jump"):
		jump()
	
	if Input.is_action_pressed("left") and _right_boot.state == Boot.State.IDLE and _state == State.IDLE:
		if _left_boot.is_pivot():
			_right_boot.state = Boot.State.LIFTING
	elif Input.is_action_just_released("left"):
		if _right_boot.state == Boot.State.LIFTED:
			_right_boot.state = Boot.State.STOMPING
		elif _right_boot.state == Boot.State.LIFTING:
			_right_boot.state = Boot.State.LOWERING
		elif _right_boot.state == Boot.State.JUMPING:
			pass
		else:
			_right_boot.state = Boot.State.IDLE

	if Input.is_action_pressed("right") and _left_boot.state == Boot.State.IDLE and _state == State.IDLE:
		if _right_boot.is_pivot():
			_left_boot.state = Boot.State.LIFTING
	elif Input.is_action_just_released("right"):
		if _left_boot.state == Boot.State.LIFTED:
			_left_boot.state = Boot.State.STOMPING
		elif _left_boot.state == Boot.State.LIFTING:
			_left_boot.state = Boot.State.LOWERING
		elif _left_boot.state == Boot.State.JUMPING:
			pass
		else:
			_left_boot.state = Boot.State.IDLE
	
	# Movement
	if _state == State.JUMPING:
		velocity = Vector2.DOWN.rotated(rotation) * jump_speed
		move_and_slide()
	
	elif _state == State.IDLE:
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
	if _invincible:
		return
	
	if enemy.damage > 0:
		var new_health = _health - enemy.damage
		set_health(new_health)
		
		$TakeDamageAudioPlayer.play()
		_invincible = true
		_invincibility_timer.start()


func on_enemy_hit(enemy: Enemy):
	var new_health = _health + enemy.health_bonus
	set_health(new_health)
	$BugDeathAudioPlayer.play()
	if enemy is SpikeyEnemy:
		$TakeDamageAudioPlayer.play()
	elif enemy is SpeedPowerUpEnemy:
		start_speed_powerup()
	elif enemy is BlastPowerupEnemy:
		$BlastPowerup._on_blast_powerup_obtained()



func set_health(health: int):
	if health <= 0:
		_health = 0
		kill()
	elif health >= 100:
		_health = 100
	else:
		_health = health
	SignalBus.player_health_changed.emit(_health)

func kill():
	killed.emit()
	hide()
	set.call_deferred("process_mode", ProcessMode.PROCESS_MODE_DISABLED)


func jump():
	_state = State.JUMPING
	_left_boot.state = Boot.State.JUMPING
	_right_boot.state = Boot.State.JUMPING
	$JumpAudioPlayer.play()
	_left_boot.jump_finished.connect(_jump_finished)
	
func start_speed_powerup():
	turn_speed = _default_turn_speed * 1.75
	jump_speed = _default_jump_speed * 1.5
	$SpeedPowerupTimer.start()

	
func end_speed_powerup():
	turn_speed = _default_turn_speed
	jump_speed = _default_jump_speed
	$SpeedPowerupTimer.stop()


func _jump_finished():
	_left_boot.jump_finished.disconnect(_jump_finished)
	_state = State.DAZED
	_daze_timer.start()
	_shockwave_animations.play("shockwave/shockwave")


func end_jump():
	_state = State.IDLE
	SignalBus.player_dazed_changed.emit(0, _daze_timer.wait_time)


func _on_speed_powerup_timer_timeout() -> void:
	end_speed_powerup()
