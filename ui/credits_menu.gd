extends Control


func _on_back_button_pressed():
	get_tree().root.add_child(load("res://ui/main_menu.tscn").instantiate())
	queue_free()
