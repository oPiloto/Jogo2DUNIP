extends CharacterBody2D


const SPEED = 170.0
const JUMP_FORCE = -320.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false

@onready var animation := $anim as AnimatedSprite2D # Vamos guardar uma referência para o nó de animação

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
		
	move_and_slide()
