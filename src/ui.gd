extends Control

@export var _game: Node

var stageScene = preload("res://src/stage.tscn")
var score := 0:
	set=set_score

var _playing := false

func _ready():
	SignalBus.enemy_hit.connect(on_enemy_hit)

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		# Toggle pause
		var paused_current = get_tree().paused
		paused(not paused_current)

func start():
	if not _game.get_children().is_empty():
		for child in _game.get_children():
			child.queue_free()

	var stage := stageScene.instantiate() as Stage
	stage.finished.connect(_on_game_over)
	_game.add_child(stage)
	$MainMenu.hide()
	$GameOverScreen.hide()
	$MainMenu/AudioStreamPlayer.stop()
	$ScoreCounter.show()
	$HealthBar.show()
	paused(false)
	score = 0
	_playing = true


func _on_game_over(FinishState):
	$GameOverScreen.show()
	$GameOverScreen/AudioStreamPlayer.play()
	$HealthBar.hide()


func on_enemy_hit(enemy_hit):
	score += 1


func quit():
	get_tree().quit()


func restart():
	$GameOverScreen/AudioStreamPlayer.stop()
	start()


func paused(value: bool):
	if _playing:
		get_tree().paused = value
		$PauseMenu.visible = value


func set_score(new_value: int):
	score = new_value
	SignalBus.score_changed.emit(score)
