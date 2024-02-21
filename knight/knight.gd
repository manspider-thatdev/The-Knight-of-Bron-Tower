extends Sprite2D


@export var target_pos := Vector2.UP


var tween: Tween
var target: Vector2


func _ready():
	GameManager.connect("game_turn", _on_game_turn)
	tween = create_tween()
	tween.kill()


func _on_game_turn(turn_time):
	target = (target_pos - position).normalized() * 16 + position
	
	tween = create_tween()
	tween.tween_property(self, "position", target, turn_time) # Move Tween
	
	await tween.finished
	tween.kill()
