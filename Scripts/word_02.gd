extends Node2D

@onready var player = $Player
@onready var player_scene = preload("res://Actors/player.tscn")
@onready var camera = $Camera
@onready var control = $HUD/Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.player = player
	Globals.player.follow_camera(camera)
	Globals.player.player_has_died.connect(reload_game)
	control.time_is_up.connect(reload_game)
	
	Globals.coins = 0
	Globals.score = 0
	Globals.player_life = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func reload_game():
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
