extends CharacterBody2D
class_name EnemyBase

const SPEED = 700.0
const JUMP_VELOCITY = -400.0

var wall_detector
var texture
@onready var animation = $animation
@export var enemy_socre = 20

var direction := -1

var can_spawn = false
var spawn_instance : PackedScene = null
var spawn_instance_pos

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _aply_gravity(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

func movement(delta):
	velocity.x = direction * SPEED * delta
	
	move_and_slide()

func flip_direction():
	if wall_detector.is_colliding():
		direction *= -1 #multiplicamos por -1 para que o direction fique positivo e inverta a direção
		wall_detector.scale.x *= -1 #vamo inverter a posição em x do raycast para que detecte colisões à esquerda também
	
	if direction == 1:
		texture.flip_h = true #para inverter a imagem 
	else:
		texture.flip_h = false 

func kill_ground_enemy(animation_name):
	kill_and_score()

func kill_air_enemy():
	kill_and_score()

func kill_and_score():
	Globals.score += enemy_socre
	if can_spawn:
		spawn_new_enemy()
		get_parent().queue_free()
	else:
		queue_free()

func spawn_new_enemy():
	var instance_scene = spawn_instance.instantiate()
	get_tree().root.add_child(instance_scene)
	instance_scene.global_position = spawn_instance_pos.global_position

func _on_hit_box_body_entered(body):
	animation.play("hurt")
