extends Area2D


func _on_area_entered(_area):
	await get_tree().process_frame
	get_tree().reload_current_scene() # Start New Level
