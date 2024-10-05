extends Node2D

@export var enemy_scene: PackedScene

@onready var spawn_point1 = $SpawnPoint1 as Marker2D
@onready var spawn_point2 = $SpawnPoint2 as Marker2D
@onready var spawn_point3 = $SpawnPoint3 as Marker2D
@onready var spawn_point4 = $SpawnPoint4 as Marker2D

var max_enemies = 10
var enemy_count 

var spawns = []
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawns.append_array([spawn_point1, spawn_point2, spawn_point3, spawn_point4])
	enemy_count = count_enemies()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	enemy_count = count_enemies()
	spawn()


func spawn():
	if enemy_count < max_enemies:
		var enemy := enemy_scene.instantiate() as Enemy
		var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
		enemy_spawn_location.progress_ratio = randf()
		var direction = enemy_spawn_location.rotation + PI / 2
		enemy.direction = direction
		enemy.position = enemy_spawn_location.position
		
		## Add some randomness to the direction.
		#direction += randf_range(-PI / 4, PI / 4)
		#mob.rotation = direction
		
		

		add_child(enemy)
		
func count_enemies():
	var enemies = 0
	var children = get_children()
	for c in children:
		if c is Enemy:
			enemies += 1
	return enemies
	


func _on_enemy_timer_timeout() -> void:
	pass # Replace with function body.
