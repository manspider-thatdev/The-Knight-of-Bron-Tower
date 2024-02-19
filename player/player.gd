class_name Player
extends Sprite2D


@onready var cast_dict = {Vector2.DOWN: $DownCast, Vector2.RIGHT: $RightCast, 
						  Vector2.LEFT: $LeftCast, Vector2.UP: $UpCast}
@onready var player_glow = $PlayerGlow


var tween: Tween


func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		player_glow.visible = !player_glow.visible
	
	var move_vector: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if move_vector.x != 0:
		move_vector.y = 0
	
	if move_vector == Vector2.ZERO or (false if not tween else tween.is_valid()):
		return
	
	move_vector = move_vector.normalized()
	if cast_dict[move_vector].is_colliding():
		return
	
	tween = create_tween()
	tween.tween_property(self, "position", position + (move_vector * 16), 1)
	await tween.finished
	tween.kill()
