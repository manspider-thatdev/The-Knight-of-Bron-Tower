extends Control


func _ready():
	pass # Could perhaps get user data


func _on_play_button_pressed():
	get_tree().root.add_child(load("res://ui/level_select.tscn").instantiate())
	queue_free()


func _on_credit_button_pressed():
	get_tree().root.add_child(load("res://ui/credits_menu.tscn").instantiate())
	queue_free()
