class_name CentimantisManager extends Node2D


@export var max_health := 10
@export var damage := 10
@export var health_bonus := 100

@export var flee_speed := 400
@export var max_speed := 200
@export var acceleration := 100

@export var follow_target: Node2D

@onready var head := $Head as Centimantis
@onready var body_1 := $Body as CentimantisFollow
@onready var body_2 := $Body2 as CentimantisFollow
@onready var body_3 := $Body3 as CentimantisFollow
@onready var tail := $Tail as CentimantisFollow

@onready var flee_timer := $FleeTimer as Timer

var _health: int
var _dead := false


func _ready():
	head.flee_speed = flee_speed
	head.max_speed = max_speed
	head.acceleration = acceleration
	head.follow_target = follow_target
	
	_health = max_health
	
	head.stomped.connect(_on_hit)
	body_1.stomped.connect(_on_hit)
	body_2.stomped.connect(_on_hit)
	body_3.stomped.connect(_on_hit)
	tail.stomped.connect(_on_hit)
	
	flee_timer.timeout.connect(activate_chase)


func activate_chase():
	head._state = Centimantis.State.CHASING
	head.damage = damage
	body_1.damage = damage
	body_2.damage = damage
	body_3.damage = damage
	tail.damage = damage


func _on_hit():
	if not _dead:
		_health += -1
		head._state = Centimantis.State.FLEEING
		flee_timer.start()
		
		# Shouldn't damage when fleeing
		head.damage = 0
		body_1.damage = 0
		body_2.damage = 0
		body_3.damage = 0
		tail.damage = 0
		
		if _health <= 0:
			_dead = true
			SignalBus.emit_signal("enemy_hit", head)
			SignalBus.emit_signal("enemy_hit", body_1)
			SignalBus.emit_signal("enemy_hit", body_2)
			SignalBus.emit_signal("enemy_hit", body_3)
			SignalBus.emit_signal("enemy_hit", tail)
			queue_free()
