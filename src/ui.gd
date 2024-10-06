extends Control

@export var _game: Node

@onready var _main_menu := $MainMenu as Control
@onready var _main_menu_focus := $MainMenu/Button as Button
@onready var _main_menu_music := $MainMenu/AudioStreamPlayer as AudioStreamPlayer

@onready var _game_over_screen := $GameOverScreen as Control
@onready var _game_over_focus := $GameOverScreen/RestartButton as Button
@onready var _game_over_music := $GameOverScreen/AudioStreamPlayer as AudioStreamPlayer

@onready var _game_ui := $GameUI

@onready var _pause_focus := $GameUI/PauseMenu/CenterContainer/VBoxContainer/ContinueButton as Button


var stageScene = preload("res://src/stage.tscn")
var score := 0:
	set=set_score

var _playing := false

func _ready():
	SignalBus.enemy_hit.connect(on_enemy_hit)
	activate_main_menu()

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		# Toggle pause
		var paused_current = get_tree().paused
		paused(not paused_current)

func start():
	stop_game()

	var stage := stageScene.instantiate() as Stage
	stage.finished.connect(_on_game_over)
	_game.add_child(stage)

	_playing = true
	activate_game_ui()
	paused(false)
	score = 0


func stop():
	stop_game()
	activate_main_menu()


func stop_game():
	if not _game.get_children().is_empty():
		for child in _game.get_children():
			child.queue_free()
	paused(true)
	_playing = false


func _on_game_over(FinishState):
	paused(true)
	activate_game_over_screen()


func on_enemy_hit(enemy_hit):
	score += 1


func quit():
	get_tree().quit()


func activate_main_menu():
	_main_menu.show()
	_main_menu_music.play()
	_game_over_screen.hide()
	_game_over_music.stop()
	_game_ui.hide()
	_main_menu_focus.grab_focus()


func activate_game_over_screen():
	_main_menu.hide()
	_main_menu_music.stop()
	_game_over_screen.show()
	_game_over_music.play()
	_game_ui.hide()
	_game_over_focus.grab_focus()


func activate_game_ui():
	_main_menu.hide()
	_main_menu_music.stop()
	_game_over_screen.hide()
	_game_over_music.stop()
	_game_ui.show()


func paused(value: bool):
	if _playing:
		get_tree().paused = value
		%PauseMenu.visible = value
	if value:
		_pause_focus.grab_focus()


func set_score(new_value: int):
	score = new_value
	SignalBus.score_changed.emit(score)
