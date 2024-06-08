extends Area2D


func _on_area_entered(_area: Area2D):
	get_parent().remove_key()
	AudioManager.door_audio.play()
	queue_free()
