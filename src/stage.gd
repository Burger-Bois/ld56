class_name Stage extends Node2D


signal finished(state: FinishState)

@export var player: Player

@export var linear_enemy_scene: PackedScene
@export var random_enemy_scene: PackedScene
@export var spikey_enemy_scene: PackedScene
@export var following_enemy_scene: PackedScene

@export var speed_powerup_scene: PackedScene


enum FinishState {GAME_OVER}

const DEFAULT_ENEMIES = 20

var _difficulty = 1
var max_enemies
var enemy_count

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_enemies = DEFAULT_ENEMIES
	$DifficultyTimer.start()
	enemy_count = count_enemies()
	$AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	enemy_count = count_enemies()


func spawn():
	if enemy_count < max_enemies:
		var enemy := get_enemy_type().instantiate() as Enemy
		var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
		enemy_spawn_location.progress_ratio = randf()
		var direction = enemy_spawn_location.rotation + PI / 2
		enemy.direction = direction
		enemy.position = enemy_spawn_location.position
		if enemy is FollowingEnemy:
			enemy._player = player
		add_child(enemy)
		
func get_enemy_type():
	var enemy_select = randi_range(1, 100)
	if enemy_select <= 20:
		return linear_enemy_scene
	elif enemy_select <= 55:
		return random_enemy_scene
	elif enemy_select <= 87:
		return spikey_enemy_scene
	elif enemy_select <= 90:
		return speed_powerup_scene
	else:
		return following_enemy_scene


func count_enemies():
	var enemies = 0
	var children = get_children()
	for c in children:
		if c is Enemy:
			enemies += 1
	return enemies


func game_over():
	$AudioStreamPlayer.stop()
	finished.emit(FinishState.GAME_OVER)
	

func _on_enemy_timer_timeout() -> void:
	spawn() 

func _on_difficulty_timer_timeout() -> void:
	_difficulty += 1
	max_enemies = DEFAULT_ENEMIES * _difficulty
	print("Max enemies set to " + str(max_enemies))
