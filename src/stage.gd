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
		var spawn_num = rng.randi_range(0, 3)
		var enemy = enemy_scene.instantiate()
		enemy.global_position = spawns[spawn_num].global_position
		add_child(enemy)
		
func count_enemies():
	var enemies = 0
	var children = get_children()
	for c in children:
		if c is Enemy:
			enemies += 1
	return enemies
	
	
	
