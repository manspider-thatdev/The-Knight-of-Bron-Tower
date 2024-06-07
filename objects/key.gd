extends Area2D


func _on_area_entered(_area: Area2D):
	get_parent().add_key()
	queue_free()
