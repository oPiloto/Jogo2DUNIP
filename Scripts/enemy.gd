extends CharacterBody2D


const SPEED = 700.0
const JUMP_VELOCITY = -400.0

@export var enemy_socre = 20

@onready var wall_detector = $WallDetector
@onready var texture = $Sprite2D
@onready var animation = $AnimationPlayer


var direction := -1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if wall_detector.is_colliding():
		direction *= -1 #multiplicamos por -1 para que o direction fique positivo e inverta a direção
		wall_detector.scale.x *= -1 #vamo inverter a posição em x do raycast para que detecte colisões à esquerda também
	
	if direction == 1:
		texture.flip_h = true #para inverter a imagem 
	else:
		texture.flip_h = false 
		
		
	velocity.x = direction * SPEED * delta

	move_and_slide()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hurt":
		queue_free()
		Globals.score += enemy_socre
