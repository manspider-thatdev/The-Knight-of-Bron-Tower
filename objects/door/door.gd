extends Area2D


const DOOR_PARTICLES = preload("res://objects/door/door_particles.tscn")


func _on_area_entered(_area: Area2D):
	get_parent().remove_key()
	AudioManager.door_audio.play()
	var particles = DOOR_PARTICLES.instantiate()
	get_tree().root.add_child(particles)
	particles.global_position = global_position
	particles.emitting = true
	queue_free()
