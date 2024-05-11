extends Sprite2D


@onready var wall_cast: DirCast = $WallDirCast
@onready var player_cast: DirCast = $PlayerDirCast
@onready var player_check_area: Area2D = $PlayerCheckArea


var target: Vector2
var post_pos: Vector2
var dir: Vector2

var move_path: Array[Vector2]

var end_level := false


func _ready():
	post_pos = global_position
	GameManager.connect("game_turn", _on_game_turn)
	
	# Wait is necessary, don't ask why
	for i in 3:
		await get_tree().physics_frame
	set_p_glow_cast()


func _on_game_turn(turn_time: float):
	find_target()
	dir = (target - global_position).normalized()
	
	if dir != Vector2.ZERO:
		move_path.push_back(dir)
	elif global_position == target and global_position != post_pos:
		dir = move_path.pop_back() * -1
		target = dir + global_position
	
	var tween = create_tween()
	tween.tween_property(self, "position", dir * 16, turn_time).set_delay(0.1).as_relative()
	
	await tween.finished
	
	if end_level: 
		get_tree().reload_current_scene() # Reset Level
	
	if dir:
		set_p_glow_cast()
	
	if player_cast.is_colliding_any():
		pass # Become Mad


func find_target():
	var collision_directions: Array[Vector2] = player_cast.get_colliding_directions()
	var p_glow_bounds: Dictionary = player_cast.get_collision_bounds()
	
	for direction in collision_directions:
		if p_glow_bounds[direction] > 0:
			target = direction * (p_glow_bounds[direction] + 4)
			target += global_position
			break


func set_p_glow_cast():
	var bound_dict = wall_cast.get_collision_bounds()
	player_cast.right_length = bound_dict[Vector2.RIGHT] - 8
	player_cast.down_length = bound_dict[Vector2.DOWN] - 8
	player_cast.left_length = bound_dict[Vector2.LEFT] - 8
	player_cast.up_length = bound_dict[Vector2.UP] - 8


func _on_player_check_area_entered(_area: Area2D):
	end_level = true
