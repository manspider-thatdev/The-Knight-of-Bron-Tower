class_name Player
extends AnimatedSprite2D


@onready var dir_cast = $DirCast
@onready var player_glow = $PlayerGlow


var target_dir := Vector2.ZERO
var can_move := true


func _ready():
	GameManager.connect("game_turn", _on_game_turn)


func _process(_delta):
	target_dir = move_inputs()
	if can_move and target_dir != Vector2.ZERO:
		can_move = false
		GameManager.emit_signal("game_turn", GameManager.turn_time)


func move_inputs() -> Vector2:
	var move_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	# Gives move direction
	if move_vector.x != 0:
		move_vector.y = 0
	move_vector = move_vector.round()
	
	if move_vector == Vector2.ZERO or dir_cast.is_colliding(move_vector): 
		return Vector2.ZERO
	
	return move_vector


func _on_game_turn(turn_time):
	var tween = create_tween()
	tween.tween_property(self, "position", target_dir * 16, turn_time).as_relative() # Move Tween
	
	await tween.finished
	can_move = true
