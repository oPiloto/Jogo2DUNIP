extends EnemyBase

func _ready():
	animation.animation_finished.connect(kill_air_enemy)
	
func _physics_process(delta):
	_aply_gravity(delta)
	movement(delta)
