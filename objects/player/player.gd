extends AnimatedSprite2D


@onready var cast_dict := {
	Vector2.DOWN: $RayCasts/DownCast, 
	Vector2.RIGHT: $RayCasts/RightCast,
	Vector2.LEFT: $RayCasts/LeftCast,
	Vector2.UP: $RayCasts/UpCast,
	}

@export_flags_2d_physics var key_layer: int
@export_flags_2d_physics var door_layer: int
@export_flags_2d_physics var pit_layer: int


var target_direction := Vector2.ZERO
var can_move := true
var key_count := 0
var advance_game := false


func _ready():
	GameManager.connect("game_turn", _on_game_turn)


func _input(event):
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()


func _process(_delta):
	if can_move:
		target_direction = move_inputs()
		if advance_game:
			can_move = false
			advance_game = false
			GameManager.emit_signal("game_turn", GameManager.turn_time)


func move_inputs() -> Vector2:
	var move_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
	if move_vector != Vector2.ZERO or Input.is_action_pressed("stay"):
		advance_game = true
	
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
	
	
	if move_vector == Vector2.ZERO:
		return move_vector
	
	if cast_dict[move_vector].is_colliding():
		var collider = cast_dict[move_vector].get_collider()
		if collider is TileMap:
			return Vector2.ZERO
		elif collider.collision_layer == pit_layer:
			collider.ignite()
			return Vector2.ZERO
		elif key_count == 0 or collider.collision_layer != door_layer:
			return Vector2.ZERO
		key_count -= 1
	return move_vector


func _on_game_turn(turn_time: float):
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", target_direction * 16.0, turn_time)\
	.as_relative()
	
	await tween.finished
	position = position.round()
	can_move = true


func _on_player_area_entered(area: Area2D):
	if area.collision_layer == key_layer:
		key_count += 1
