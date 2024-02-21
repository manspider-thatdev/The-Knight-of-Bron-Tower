class_name Player
extends Sprite2D


@onready var cast_dict = {Vector2.DOWN: $DownCast, Vector2.RIGHT: $RightCast, 
						  Vector2.LEFT: $LeftCast, Vector2.UP: $UpCast}
@onready var player_glow = $PlayerGlow


var tween: Tween
var target := Vector2.ZERO
var glow_energy := true


func _ready():
	GameManager.connect("game_turn", _on_game_turn)
	tween = create_tween()
	tween.kill()


func _process(_delta):
	if not tween.is_valid() and (glow_inputs() or move_inputs()):
		GameManager.emit_signal("game_turn", GameManager.turn_time)


func glow_inputs() -> bool:
	if not Input.is_action_just_pressed("ui_accept"):
		return false
	
	glow_energy = !glow_energy
	return true


func move_inputs() -> bool:
	var move_vector: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if move_vector.x != 0:
		move_vector.y = 0
	move_vector = move_vector.normalized()
	
	if move_vector == Vector2.ZERO or cast_dict[move_vector].is_colliding(): 
		return false
	
	target = position + (move_vector * 16)
	return true


func _on_game_turn(turn_time):
	tween = create_tween()
	tween.tween_property(player_glow, "energy", int(glow_energy), turn_time) # Glow Tween
	tween.parallel().tween_property(self, "position", target, turn_time) # Move Tween
	
	await tween.finished
	tween.kill()
