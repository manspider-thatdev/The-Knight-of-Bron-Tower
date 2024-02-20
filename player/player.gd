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
	if tween.is_valid(): 
		return
	
	if Input.is_action_just_pressed("ui_accept"):
		glow_energy = !glow_energy
	
	var move_vector: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if move_vector.x != 0:
		move_vector.y = 0
	move_vector = move_vector.normalized()
	
	if move_vector == Vector2.ZERO or cast_dict[move_vector].is_colliding(): 
		return
	
	target = position + (move_vector * 16)
	
	GameManager.emit_signal("game_turn")


func _on_game_turn():
	tween = create_tween()
	tween.tween_property(self, "position", target, 1) # Move Tween
	tween.parallel().tween_property(player_glow, "energy", int(glow_energy), 1) # Glow Tween
	
	await tween.finished
	tween.kill()
