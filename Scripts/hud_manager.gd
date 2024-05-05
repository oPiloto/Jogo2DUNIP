extends Control


@onready var coins_counter = $MarginContainer/coins/counter as Label
@onready var life_counter = $MarginContainer/life/counter as Label
@onready var time_counter = $MarginContainer/time/counter as Label
@onready var score_counter = $MarginContainer/score/counter as Label
@onready var clock_timer = $ClockTimer as Timer

var min = 0
var sec = 0
@export_range(0, 5) var default_min = 1
@export_range(0, 59) var default_sec = 0

signal time_is_up()

# Called when the node enters the scene tree for the first time.
func _ready():
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%04d" % Globals.score)
	life_counter.text = str("%02d" % Globals.player_life)
	time_counter.text = str("%02d" % default_min) + ":" + str("%02d " % default_sec)
	reset_clock()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%04d" % Globals.score)
	life_counter.text = str("%02d" % Globals.player_life)
	
	if min == 0 and sec == 0:
		emit_signal("time_is_up")


func _on_clock_timer_timeout():
	if sec == 0:
		if min > 0:
			min -= 1
			sec = 60
	sec -= 1
	
	time_counter.text = str("%02d" % min) + ":" + str("%02d" % sec)

func reset_clock():
	min = default_min
	sec = default_sec
