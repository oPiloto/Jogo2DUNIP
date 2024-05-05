extends CharacterBody2D


const SPEED = 170.0
const JUMP_FORCE = -320.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false

var knockback_vector = Vector2.ZERO

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
	var direction = Input.get_axis("move_left", "move_right")
	
	# Mudar a direção do sprite
	if direction != 0:
		velocity.x = direction * SPEED
		animation.scale.x = direction # x = 1 direita, x = -1 esquerda. Assim setamos quando o personagem anda para direita ou para esquerda
		
		if !is_jumping:
			animation.play("run")
		elif is_jumping:
			animation.play("jump")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("idle")
	
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	
	move_and_slide()
	
	for platforms in get_slide_collision_count():
		var colision = get_slide_collision(platforms)
		if colision.get_collider().has_method("has_collided"):
			colision.get_collider().has_collided(colision, self)


func _on_hurt_box_body_entered(body):
	if ray_right.is_colliding():
		take_damage(Vector2(-150, -150))
	elif ray_left.is_colliding():
		take_damage(Vector2(150, -150))

func follow_camera(camera):
	remote_transform_2d.remote_path = camera.get_path()

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	if Globals.player_life > 0:
		Globals.player_life -= 1
	else:
		queue_free()
		emit_signal("player_has_died")
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1, 0, 0, 1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1, 1, 1, 1), duration)
