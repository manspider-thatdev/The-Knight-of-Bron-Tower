extends AnimatedSprite2D


enum TargetType {
	POST = 0,
	PLAYER = 1,
}

enum Direction { LEFT, RIGHT, DOWN, UP }

@onready var raycasts: Array[RayCast2D] = [
	$RayCasts/ForwardCast,
	$RayCasts/LeftCast,
	$RayCasts/RightCast,
	]

@export var default_face := Direction.DOWN:
	set(value):
		default_face = value
		if value == Direction.LEFT:
			default_direction = Vector2.LEFT
		elif value == Direction.RIGHT:
			default_direction = Vector2.RIGHT
		elif value == Direction.DOWN:
			default_direction = Vector2.DOWN
		elif value == Direction.UP:
			default_direction = Vector2.UP
@export var post_positions: Array[Vector2]


var default_direction: Vector2
var post_index: int = 0:
	set(value):
		post_index = wrapi(post_index, 0, post_positions.size())

var target: Vector2
var target_direction: Vector2
var target_type: TargetType

var end_level := false


func _ready():
	GameManager.connect("game_turn", _on_game_turn)
	
	global_position = post_positions[post_index]
	post_index += 1
	target = post_positions[post_index]
	
	set_animation_direction(default_direction)


func _on_game_turn(turn_time: float):
	target_direction = target - global_position
	
	if target_direction != Vector2.ZERO:
		target_direction = target_direction.normalized()
		set_raycasts(target_direction)
	else:
		set_raycasts(default_direction)
	
	# Set animations for direction
	var animation_suffix := animation.get_slice("_", 1)
	set_animation_direction(target_direction, animation_suffix)
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", target_direction * 16, turn_time)\
	.as_relative()
	
	# Wait to be done moving
	await tween.finished
	
	if end_level: 
		get_tree().reload_current_scene() # Reset Level
	
	set_target()
	
	# Animation mad to calm or calm to mad
	var animation_prefix := animation.get_slice("_", 0)
	animation_suffix = "calm" if target_type == TargetType.POST else "mad"
	play(animation_prefix + "_" + animation_suffix)


func set_target():
	if global_position == target:
		if target_type == TargetType.POST:
			post_index += 1
		target_type = TargetType.POST
	
	for raycast in raycasts:
		var collider: Node2D = raycast.get_collider()
		if !collider or collider.get_class() == "TileMap":
			continue
		
		# Sees Player
		target = collider.global_position
		target_type = TargetType.PLAYER
	
	if target_type == TargetType.POST:
		target = post_positions[post_index]


func set_raycasts(direction: Vector2):
	var ortho_vector := direction.orthogonal()
	
	raycasts[0].target_position = direction * 256
	raycasts[1].target_position = ortho_vector * 256
	raycasts[2].target_position = -ortho_vector * 256


func set_animation_direction(direction: Vector2, suffix := "calm"):
	if direction == Vector2.LEFT:
		play("left_" + suffix)
	elif direction == Vector2.RIGHT:
		play("right_" + suffix)
	elif direction == Vector2.DOWN:
		play("down_" + suffix)
	elif direction == Vector2.UP:
		play("up_" + suffix)
	else:
		play(str(Direction.keys()[default_face]).to_lower() + "_" + suffix)


# Used to wait for end of turn to end level
func _on_player_check_area_entered(_area: Area2D):
	end_level = true
