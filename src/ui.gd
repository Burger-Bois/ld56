extends Control

var stageScene = preload("res://src/stage.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	print("HELL")
	var stage = stageScene.instantiate()
	$".".get_parent().add_child(stage)
	$".".get_parent().remove_child($".")
