extends Control

var stageScene = preload("res://src/stage.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func start():
	#var stage := stageScene.instantiate() as Stage
	#stage.finished.connect(_on_game_over)
	#$".".get_parent().find_child("game").add_child(stage)
	$Panel.hide()
	$Panel2.hide()
	$Panel/AudioStreamPlayer.stop()
	_on_game_over(Stage.FinishState.GAME_OVER)



func _on_game_over(FinishState):
	print("FUCK!!!!!")
	$Panel2.show()

func quit():
	get_tree().quit()


func restart():
	start()
