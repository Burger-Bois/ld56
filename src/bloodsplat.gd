class_name BloodSplat extends Sprite2D


@export var textures: Array[Texture2D]


func _ready():
	var texture_i := randi_range(0, textures.size() - 1)
	texture = textures[texture_i]
