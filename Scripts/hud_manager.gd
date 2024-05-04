extends Control


@onready var coins_counter = $MarginContainer/coins/counter as Label
@onready var life_counter = $MarginContainer/life/counter as Label
@onready var time_counter = $MarginContainer/time/counter as Label
@onready var score_counter = $MarginContainer/score/counter as Label


# Called when the node enters the scene tree for the first time.
func _ready():
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%04d" % Globals.score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%04d" % Globals.score)
