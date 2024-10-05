class_name Boot extends Node2D


@export var state: State = State.IDLE:
	set=set_state

enum State {IDLE, LIFTING, LOWERING, LIFTED, STOMPING}

var _damage_box_enemies: Array[Enemy] = []

@onready var _animations := $AnimationPlayer as AnimationPlayer
@onready var _damage_box := $DamageBox as Area2D


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
	if animation == "boot/lift":
		if state == State.LIFTING:
			state = State.LIFTED
		if state == State.LOWERING:
			state = State.IDLE
	if animation == "boot/stomp":
		state = State.IDLE


func add_damage_box_enemy(node: Node2D):
	if node is Enemy:
		_damage_box_enemies.append(node)


func remove_damage_box_enemy(node: Node2D):
	if node in _damage_box_enemies:
		_damage_box_enemies.erase(node)


func stomp():
	print("stomping")
	for enemy in _damage_box_enemies:
		print("stomping: " + enemy.name)
		enemy.hit()
