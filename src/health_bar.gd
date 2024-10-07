class_name HealthBar extends ProgressBar


@onready var _label := $HealthValue as Label


func _ready():
	SignalBus.player_health_changed.connect(update_value)


func update_value(new_value: int):
	value = new_value
	_label.text = str(new_value) + " / 100"

