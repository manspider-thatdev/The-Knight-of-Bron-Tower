extends Area2D


func _on_area_entered(_area):
	await get_tree().process_frame
	AudioManager.win_audio.play()
	GameManager.load_next_level(get_parent())
