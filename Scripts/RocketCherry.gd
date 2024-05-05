extends CharacterBody2D

@export var enemy_socre = 100
@onready var animation = $animation

func _on_hit_box_body_entered(body):
	animation.play("hurt")

func _on_animation_animation_finished():
	if animation.animation == "hurt":
		queue_free()
		Globals.score += enemy_socre
