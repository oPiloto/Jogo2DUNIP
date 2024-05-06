extends CharacterBody2D


const SPEED = 170.0
const JUMP_FORCE = -320.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false
var is_hurted := false
var knockback_vector = Vector2.ZERO
var knockback_power = 15
var direction

@onready var collision_shape_2d = $CollisionShape2D
@onready var animation := $anim as AnimatedSprite2D # Vamos guardar uma referência para o nó de animação
@onready var remote_transform_2d = $RemoteTransform2D
@onready var ray_right = $ray_right
@onready var ray_left = $ray_left

signal player_has_died()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
		
	elif is_on_floor():
		is_jumping = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("move_left", "move_right")
	
	# Mudar a direção do sprite
	if direction != 0:
		velocity.x = direction * SPEED
		animation.scale.x = direction # x = 1 direita, x = -1 esquerda. Assim setamos quando o personagem anda para direita ou para esquerda
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	
	for platforms in get_slide_collision_count():
		var colision = get_slide_collision(platforms)
		if colision.get_collider().has_method("has_collided"):
			colision.get_collider().has_collided(colision, self)
	
	_set_state()
	move_and_slide()

func _on_hurt_box_body_entered(body):
	var knockback = Vector2((global_position.x - body.global_position.x) * knockback_power, -150)
	take_damage(knockback)

func follow_camera(camera):
	remote_transform_2d.remote_path = camera.get_path()

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	if Globals.player_life > 0:
		Globals.player_life -= 1
	else:
		collision_shape_2d.queue_free()
		emit_signal("player_has_died")
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1, 0, 0, 1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1, 1, 1, 1), duration)
	
	# Toma o dana e depois de .2s volta a animação idle
	is_hurted = true
	await get_tree().create_timer(.4).timeout
	is_hurted = false

# Gerencia animação
func _set_state():
	var state = "idle"
	
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
	
	if is_hurted:
		state = "hurt"
	
	if animation.name != state:
		animation.play(state)
