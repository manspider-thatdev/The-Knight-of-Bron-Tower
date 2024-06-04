extends Area2D


func _on_area_entered(_area):
	await get_tree().process_frame
	GameManager.load_next_level(get_parent())
