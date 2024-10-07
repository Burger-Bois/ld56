class_name CentimantisFollow extends Enemy


signal stomped

@export var distance := 64.0

@export var follow_target: Node2D


func _physics_process(delta):
	var vector_to := follow_target.global_position - global_position
	
	# Only follow if it's beyond the max distance
	if vector_to.length() >= 64:
		var distance_vector = vector_to.normalized() * distance
		velocity = vector_to - distance_vector
		position += velocity
	
	rotation = global_position.angle_to_point(follow_target.global_position)


func hit():
	stomped.emit()


func remove():
	pass


func blast(push_direction: Vector2):
	pass
