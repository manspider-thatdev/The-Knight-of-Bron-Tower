extends Control


@onready var button_container = $LevelContainer/ButtonContainer


func _ready():
	$LevelContainer/ButtonContainer/Button.grab_focus()
	button_container.get_child(0).pressed.connect(_on_level_button_pressed.bind(0))
	for i in GameManager.levels.size() - 1:
		var new_button_container := button_container.duplicate()
		$LevelContainer.add_child(new_button_container)
		var button := new_button_container.get_child(0) as Button
		button.text = str(i + 2)
		button.pressed.connect(_on_level_button_pressed.bind(i + 1))
		if i + 1 > GameManager.farthest_level:
			button.disabled = true


func _on_back_button_pressed():
	ScreenTransition.change_scene("res://ui/main_menu.tscn", \
			ScreenTransition.SLIDE, ScreenTransition.SLIDE)


func _on_level_button_pressed(level_id: int):
	GameManager.load_level(level_id)
