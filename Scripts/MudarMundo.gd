extends CanvasLayer

@onready var color_rect = $ColorRect

func _ready():
	show_new_scene()

func change_scene(path):
	var scene_transition = get_tree().create_tween()
	scene_transition.tween_property(color_rect, "progress", 1.0, 1.2)
	await scene_transition.finished
	assert(get_tree().change_scene_to_file(path) == OK)

func show_new_scene():
	var scene_transition = get_tree().create_tween()
	scene_transition.tween_property(color_rect, "progress", 0.0, 0.5).from(1.0)
	
