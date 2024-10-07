class_name Enemy extends CharacterBody2D

@export var direction := 0.0:
	set=set_direction
@export var speed = 70.0

const BLAST_SPEED = 250

var damage = 10
var health_bonus = 5

var _dead := false
var _is_pushed := false

var _push_direction


func hit():
	if not _dead:
		_dead = true
		SignalBus.emit_signal("enemy_hit", self)
		queue_free()


func remove():
	queue_free()


func set_direction(new_direction: float):
	direction = new_direction
	rotation = new_direction
	
func blast(push_direction: Vector2):
	_push_direction = push_direction
	_is_pushed = true
	$BlastTimer.start()
	
