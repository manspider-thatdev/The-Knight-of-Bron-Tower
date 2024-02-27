extends Sprite2D


@onready var wall_cast = $WallDirCast
@onready var p_glow_dir_cast = $PGlowDirCast
@onready var player_check_area = $PlayerCheckArea


var target: Vector2
var post_pos: Vector2
var tween: Tween
var dir: Vector2

var move_path: Array[Vector2]


func _ready():
	target = position
	post_pos = position
	GameManager.connect("game_turn", _on_game_turn)
	
	for i in 3:
		await get_tree().physics_frame
	set_p_glow_cast()


func _on_game_turn(turn_time):
	find_target()
	dir = (target - position).normalized() * 16
	
	if dir != Vector2.ZERO:
		move_path.push_back(dir * 0.0625)
	elif position == target and position != post_pos:
		dir = move_path.pop_back() * -16
		target = dir + position
	
	tween = create_tween()
	tween.tween_property(self, "position", dir + position, turn_time) # Move Tween
	
	await tween.finished
	tween.kill()
	
	if not player_check_area.get_overlapping_areas().is_empty():
		get_tree().reload_current_scene()
	if dir:
		set_p_glow_cast()


func find_target():
	var collision_directions = p_glow_dir_cast.get_colliding_directions()
	var p_glow_bounds: Dictionary = p_glow_dir_cast.get_collision_bounds()
	
	for direction in collision_directions:
		if p_glow_bounds[direction] > 0:
			target = direction * (p_glow_bounds[direction] + 8)
			target += global_position
			break


func set_p_glow_cast():
	var bound_dict = wall_cast.get_collision_bounds()
	p_glow_dir_cast.right_length = bound_dict[Vector2.RIGHT] - 8
	p_glow_dir_cast.down_length = bound_dict[Vector2.DOWN] - 8
	p_glow_dir_cast.left_length = bound_dict[Vector2.LEFT] - 8
	p_glow_dir_cast.up_length = bound_dict[Vector2.UP] - 8
