extends CharacterBody2D

class_name Enemy

@export var direction := 0.0

const SPEED = 75.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	velocity = Vector2.RIGHT.rotated(direction) * SPEED
	move_and_slide()
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func hit():
	print("ouchy, I've been hit: " + name)
	queue_free()
