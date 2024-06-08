extends Area2D


func _on_area_entered(_area: Area2D):
	get_parent().add_key()
	AudioManager.key_audio.play()
	queue_free()
