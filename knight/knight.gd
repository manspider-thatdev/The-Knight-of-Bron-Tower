extends Sprite2D


@onready var wall_cast = $WallDirCast
@onready var p_glow_dir_cast = $PGlowDirCast


var target: Vector2
var tween: Tween
var dir: Vector2


func _ready():
	target = position
	GameManager.connect("game_turn", _on_game_turn)
	
	for i in 3:
		await get_tree().physics_frame
	set_p_glow_cast()


func _on_game_turn(turn_time):
	dir = (target - position).normalized() * 16 + position
	
	var does_move = target != position
	
	tween = create_tween()
	tween.tween_property(self, "position", dir, turn_time) # Move Tween
	
	await tween.finished
	tween.kill()
	
	if does_move:
		set_p_glow_cast()


func set_p_glow_cast():
	var bound_dict = wall_cast.get_collision_bounds()
	p_glow_dir_cast.right_length = bound_dict[Vector2.RIGHT] - 8
	p_glow_dir_cast.down_length = bound_dict[Vector2.DOWN] - 8
	p_glow_dir_cast.left_length = bound_dict[Vector2.LEFT] - 8
	p_glow_dir_cast.up_length = bound_dict[Vector2.UP] - 8
