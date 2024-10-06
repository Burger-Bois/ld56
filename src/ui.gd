extends Control

@export var _game: Node

var stageScene = preload("res://src/stage.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func start():
	if not _game.get_children().is_empty():
		for child in _game.get_children():
			child.queue_free()

	var stage := stageScene.instantiate() as Stage
	stage.finished.connect(_on_game_over)
	_game.add_child(stage)
	$Panel.hide()
	$Panel2.hide()
	$Panel/AudioStreamPlayer.stop()



func _on_game_over(FinishState):
	print("FUCK!!!!!")
	$Panel2.show()

func quit():
	get_tree().quit()


func restart():
	start()
