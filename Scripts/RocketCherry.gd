extends EnemyBase

@onready var spawn = $"../Spawn"

func _ready():
	spawn_instance = preload("res://Actors/cherry.tscn")
	spawn_instance_pos = spawn
	can_spawn = true
	animation.animation_finished.connect(kill_air_enemy)
