class_name ScoreCounter extends RichTextLabel


func _ready():
	SignalBus.score_changed.connect(update_value)


func update_value(value: int):
	text = "Score:" + str(value)
