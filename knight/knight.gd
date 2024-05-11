extends Sprite2D


enum TargetType {
	POST = 0,
	PLAYER = 1,
}

@onready var cast_dict := {
	Vector2.DOWN: $WallDirCast/DownCast,
	Vector2.RIGHT: $WallDirCast/RightCast,
	Vector2.LEFT: $WallDirCast/LeftCast,
	Vector2.UP: $WallDirCast/UpCast,
	}

@export var post_positions: Array[Vector2]


var post_index: int = 0:
	set(value):
		post_index = wrapi(post_index, 0, post_positions.size())

var target: Vector2

var end_level := false


func _ready():
	global_position = post_positions[post_index]
	post_index += 1
	target = post_positions[post_index]
	GameManager.connect("game_turn", _on_game_turn)


func _on_game_turn(turn_time: float):
	var target_direction: Vector2 = target - global_position
	
	if target_direction:
		target_direction = target_direction.normalized()
		var ortho_vector := target_direction.orthogonal()
		
		cast_dict[target_direction].enabled = true
		cast_dict[ortho_vector].enabled = true
		cast_dict[-ortho_vector].enabled = true
		cast_dict[-target_direction].enabled = false  # Knight can't see behind itself
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", target_direction * 16, turn_time)\
	.set_delay(0.1).as_relative()
	
	await tween.finished
	
	if end_level: 
		get_tree().reload_current_scene() # Reset Level
	
	#if player_cast.is_colliding_any():
		#pass # Become Mad
	
	set_target()


func set_target():
	pass


# Used to wait for end of turn to end level
func _on_player_check_area_entered(_area: Area2D):
	end_level = true
