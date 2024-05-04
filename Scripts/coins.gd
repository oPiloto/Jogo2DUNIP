extends Area2D

func _on_body_entered(body):
	$Anim.play("collect")


func _on_anim_animation_finished():
	if $Anim.animation == "collect":
		await $Collision.call_deferred("queue_free")
		Globals.coins += 1
		queue_free()
