class_name Boot extends Node2D


@export var state: State = State.IDLE:
	set=set_state

enum State {IDLE, LIFTING, LOWERING, LIFTED, STOMPING}

@onready var _animations := $AnimationPlayer


func _ready():
	_animations.animation_finished.connect(_on_animation_finished)


func set_state(new_state: State):
	if new_state == State.IDLE:
		_animations.speed_scale = 1
		_animations.play("RESET")
	
	if new_state == State.LIFTING:
		_animations.speed_scale = 1
		_animations.play("boot/lift")
	
	if new_state == State.STOMPING:
		_animations.speed_scale = 1
		_animations.play("boot/stomp")
	
	if new_state == State.LOWERING and _animations.current_animation == "boot/lift":
		_animations.speed_scale = -3
	
	state = new_state


func is_pivot():
	return [State.IDLE, State.LOWERING, State.STOMPING].has(state)


func _on_animation_finished(animation: String):
	print("animation finished: " + animation)
	if animation == "boot/lift":
		if state == State.LIFTING:
			state = State.LIFTED
		if state == State.LOWERING:
			state = State.IDLE
	if animation == "boot/stomp":
		state = State.IDLE
