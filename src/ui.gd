extends Control

@export var _game: Node

var stageScene = preload("res://src/stage.tscn")
var score = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.enemy_hit.connect(on_enemy_hit)

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
	$RichTextLabel.show()



func _on_game_over(FinishState):
	print("FUCK!!!!!")
	$Panel2.show()

func on_enemy_hit(enemy_hit):
	score += 1
	$RichTextLabel.clear()
	$RichTextLabel.add_text("Score:" + str(score))

func quit():
	get_tree().quit()


func restart():
	$RichTextLabel.clear()
	start()
