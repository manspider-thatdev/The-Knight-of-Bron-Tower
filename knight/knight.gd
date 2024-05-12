extends AnimatedSprite2D


enum TargetType {
	POST = 0,
	PLAYER = 1,
}

@onready var raycasts: Array[RayCast2D] = [
	$RayCasts/ForwardCast,
	$RayCasts/LeftCast,
	$RayCasts/RightCast,
	]

@export var post_positions: Array[Vector2]


var post_index: int = 0:
	set(value):
		post_index = wrapi(post_index, 0, post_positions.size())

var target: Vector2
var target_direction: Vector2
var target_type: TargetType

var end_level := false


func _ready():
	global_position = post_positions[post_index]
	post_index += 1
	target = post_positions[post_index]
	
	GameManager.connect("game_turn", _on_game_turn)


func _on_game_turn(turn_time: float):
	target_direction = target - global_position
	
	if target_direction != Vector2.ZERO:
		target_direction = target_direction.normalized()
		var ortho_vector := target_direction.orthogonal()
		
		raycasts[0].target_position = target_direction * 256
		raycasts[1].target_position = ortho_vector * 256
		raycasts[2].target_position = -ortho_vector * 256
	
	# Set animations for direction
	var animation_suffix = animation.get_slice("_", 1)
	if target_direction == Vector2.LEFT:
		play("left_" + animation_suffix)
	elif target_direction == Vector2.RIGHT:
		play("right_" + animation_suffix)
	elif target_direction == Vector2.DOWN:
		play("down_" + animation_suffix)
	elif target_direction == Vector2.UP:
		play("up_" + animation_suffix)
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", target_direction * 16, turn_time)\
	.as_relative()
	
	await tween.finished
	
	if end_level: 
		get_tree().reload_current_scene() # Reset Level
	
	set_target()


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
	
	# Animation mad to calm or calm to mad
	var animation_prefix = animation.get_slice("_", 0)
	var animation_suffix := "calm" if target_type == TargetType.POST else "mad"
	play(animation_prefix + "_" + animation_suffix)


# Used to wait for end of turn to end level
func _on_player_check_area_entered(_area: Area2D):
	end_level = true
