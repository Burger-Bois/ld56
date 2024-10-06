class_name HealthBar extends ProgressBar


func _ready():
	SignalBus.player_health_changed.connect(update_value)


func update_value(new_value: int):
	value = new_value

