extends Area2D

@onready var coin_sound = $coin_sound

func _on_body_entered(body):
	$Anim.play("collect")
	coin_sound.play()

func _on_anim_animation_finished():
	if $Anim.animation == "collect":
		await $Collision.call_deferred("queue_free")
		Globals.coins += 1
		queue_free()
