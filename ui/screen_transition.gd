extends Control


enum {
	SLIDE,
	FADE,
}


@onready var panel = $Panel


func change_scene(scene_file: String, out_trans, in_trans):
	var tween: Tween = create_tween()
	
	if out_trans == SLIDE:
		tween.tween_property(panel, "anchor_right", 1.0, 0.2)
	elif out_trans == FADE:
		panel.modulate = Color.TRANSPARENT
		panel.anchor_right = 1.0
		tween.tween_property(panel, "modulate", Color.WHITE, 0.2)
	
	tween.tween_callback(get_tree().change_scene_to_file.bind(scene_file))
	
	if in_trans == SLIDE:
		tween.tween_property(panel, "anchor_left", 1.0, 0.2)
	elif in_trans == FADE:
		tween.tween_property(panel, "modulate", Color.TRANSPARENT, 0.2)
	
	await tween.finished
	
	panel.anchor_left = 0.0
	panel.anchor_right = 0.0
	panel.modulate = Color.WHITE
