extends Area2D

@onready var mudar_mundo = get_parent().get_node("MudarMundo")
@export var next_level : String = ""

func _on_body_entered(body):
	if body.name == "Player" and next_level != "":
		mudar_mundo.change_scene(next_level)
	else:
		print("SEM MUNDO CARREGADO")
