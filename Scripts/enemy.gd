extends CharacterBody2D


const SPEED = 700.0
const JUMP_VELOCITY = -400.0

@onready var wal_detector := $wall_detector as RayCast2D #vamos criar uma referencia para nosso raycast
@onready var texture := $Texture as Sprite2D

var direction := -1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if wal_detector.is_colliding():
		direction *= -1 #multiplicamos por -1 para que o direction fique positivo e inverta a direção
		wal_detector.scale.x *= -1 #vamo inverter a posição em x do raycast para que detecte colisões à esquerda também
	
	if direction == 1:
		texture.flip_h = true #para inverter a imagem 
	else:
		texture.flip_h = false 
		
		
	velocity.x = direction * SPEED * delta

	move_and_slide()
