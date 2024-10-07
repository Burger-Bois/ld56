class_name Enemy extends CharacterBody2D

@export var direction := 0.0:
	set=set_direction
@export var speed = 70.0

var damage = 10
var health_bonus = 5


func hit():
	SignalBus.emit_signal("enemy_hit", self)
	queue_free()


func remove():
	queue_free()


func set_direction(new_direction: float):
	direction = new_direction
	rotation = new_direction
