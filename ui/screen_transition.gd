extends Control

@onready var panel = $Panel

func change_scene(scene_file):
	var tween: Tween = create_tween()
	tween.tween_property(panel, "anchor_right", 1.0, 0.2)
	tween.tween_callback(get_tree().change_scene_to_file.bind(scene_file))
	tween.tween_property(panel, "anchor_left", 1.0, 0.2)
	
	await tween.finished
	
	panel.anchor_left = 0.0
	panel.anchor_right = 0.0
