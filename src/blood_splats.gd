class_name BloodSplats extends Node2D


@export var blood_splat_scene: PackedScene


func _ready():
	SignalBus.enemy_hit.connect(create_bloodsplat)


func create_bloodsplat(node: Node2D):
	var blood_splat := blood_splat_scene.instantiate() as BloodSplat
	blood_splat.global_position = floor(node.global_position)
	blood_splat.rotation = randi_range(0, 3) * (TAU / 4)
	add_child(blood_splat)
