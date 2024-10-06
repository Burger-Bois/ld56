extends CharacterBody2D

class_name Enemy

@export var direction := 0.0
@export var speed = 70.0

var damage = 10
var health_bonus = 5


func hit():
	SignalBus.emit_signal("enemy_hit", self)
	queue_free()


func remove():
	queue_free()
