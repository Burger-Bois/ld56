extends Node2D


signal finished(state: FinishState)

@export var linear_enemy_scene: PackedScene
@export var random_enemy_scene: PackedScene

enum FinishState {GAME_OVER}

var max_enemies = 50
var enemy_count

var enemies
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemies = [linear_enemy_scene, random_enemy_scene]
	enemy_count = count_enemies()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	enemy_count = count_enemies()


func spawn():
	if enemy_count < max_enemies:
		var enemy_select = randi_range(0, enemies.size() - 1)
		var enemy := enemies[enemy_select].instantiate() as Enemy
		var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
		enemy_spawn_location.progress_ratio = randf()
		var direction = enemy_spawn_location.rotation + PI / 2
		enemy.direction = direction
		enemy.position = enemy_spawn_location.position
		add_child(enemy)

func count_enemies():
	var enemies = 0
	var children = get_children()
	for c in children:
		if c is Enemy:
			enemies += 1
	return enemies


func game_over():
	finished.emit(FinishState.GAME_OVER)


func _on_enemy_timer_timeout() -> void:
	spawn() 
