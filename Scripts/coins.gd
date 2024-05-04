extends Area2D

@onready var game_manager = %GameManager

func _on_body_entered(body):
	$Anim.play("collect")


func _on_anim_animation_finished():
	if $Anim.animation == "collect":
		game_manager.add_coin()
		queue_free()
