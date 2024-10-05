extends CharacterBody2D

class_name Enemy

@export var direction := 0.0

const SPEED = 75.0


func hit():
	queue_free()


func remove():
	queue_free()
