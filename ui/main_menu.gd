extends Control


func _ready():
	$PlayButton.grab_focus()


func _on_play_button_pressed():
	ScreenTransition.change_scene("res://ui/level_select.tscn")


func _on_credit_button_pressed():
	ScreenTransition.change_scene("res://ui/credits_menu.tscn")
