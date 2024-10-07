extends Area2D


func _on_blast_powerup_obtained():
	var enemies = get_overlapping_bodies()
	for e in enemies:
		if e is Enemy:
			print("Enemy to be blasted")
			var direction = global_position.direction_to(e.global_position)
			e.blast(direction)
