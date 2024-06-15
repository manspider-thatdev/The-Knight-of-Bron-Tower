extends Control


func _ready():
	$BackButton.grab_focus()


func _on_back_button_pressed():
	ScreenTransition.change_scene("res://ui/main_menu.tscn")
