extends EnemyBase

func _ready():
	wall_detector = $WallDetector
	texture = $Sprite2D
	animation.animation_finished.connect(kill_ground_enemy)

func _physics_process(delta):
	_aply_gravity(delta)
	movement(delta)
	flip_direction()
