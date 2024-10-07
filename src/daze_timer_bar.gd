extends ProgressBar


func _ready():
	SignalBus.player_dazed_changed.connect(update_timer)


func update_timer(time_left: float, wait_time: float):
	max_value = wait_time
	value = max_value - time_left
	
	if value == max_value:
		hide()
	else:
		show()
