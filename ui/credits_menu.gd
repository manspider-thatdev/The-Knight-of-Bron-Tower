extends Control


const MAIN_MENU = preload("res://ui/main_menu.tscn")


func _on_back_button_pressed():
	get_tree().root.add_child(MAIN_MENU.instantiate())
	queue_free()
