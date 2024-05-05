extends Area2D

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	collision_shape_2d.shape.size = sprite_2d.get_rect().size

func _on_body_entered(body):
	if body.name == "Player" &&body.has_method("take_damage"):
		body.take_damage(Vector2(0, -220))
