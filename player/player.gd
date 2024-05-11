extends AnimatedSprite2D


@onready var cast_dict := {
	Vector2.DOWN: $RayCasts/DownCast, 
	Vector2.RIGHT: $RayCasts/RightCast,
	Vector2.LEFT: $RayCasts/LeftCast,
	Vector2.UP: $RayCasts/UpCast,
	}


var target_direction := Vector2.ZERO
var can_move := true


func _ready():
	GameManager.connect("game_turn", _on_game_turn)


func _process(_delta):
	if can_move:
		target_direction = move_inputs()
		if target_direction != Vector2.ZERO:
			can_move = false
			GameManager.emit_signal("game_turn", GameManager.turn_time)


func move_inputs() -> Vector2:
	var move_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	# Gives move direction
	if move_vector.x != 0:
		move_vector.y = 0
	move_vector = move_vector.round()
	
	# Animations
	if move_vector == Vector2.LEFT:
		play("left")
	elif move_vector == Vector2.RIGHT:
		play("right")
	elif move_vector == Vector2.DOWN:
		play("down")
	elif move_vector == Vector2.UP:
		play("up")
	
	# Returns
	if move_vector == Vector2.ZERO or cast_dict[move_vector].is_colliding(): 
		return Vector2.ZERO
	
	return move_vector


func _on_game_turn(turn_time: float):
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", target_direction * 16, turn_time)\
	.as_relative()
	
	await tween.finished
	can_move = true
