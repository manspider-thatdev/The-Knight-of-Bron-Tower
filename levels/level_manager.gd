extends TileMap


const KEY_TEXTURE = preload("res://ui/reused/key_texture.tscn")


func _ready():
	$LevelUI/Label.text = "Level " + str(GameManager.level_id + 1)


func add_key():
	$LevelUI/KeyContainer.add_child(KEY_TEXTURE.instantiate())


func remove_key():
	$LevelUI/KeyContainer.get_child(-1).queue_free()


func _on_back_button_pressed():
	ScreenTransition.change_scene("res://ui/level_select.tscn", \
			ScreenTransition.FADE, ScreenTransition.SLIDE)
