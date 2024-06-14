extends AnimatedSprite2D


enum TargetType {
	POST = 0,
	FIRE = 1,
	PLAYER = 2,
}

enum Direction { LEFT, RIGHT, DOWN, UP }

@onready var raycasts: Array[RayCast2D] = [
	$RayCasts/ForwardCast,
	$RayCasts/LeftCast,
	$RayCasts/RightCast,
	]

@export_flags_2d_physics var door_layer: int
@export_flags_2d_physics var pit_layer: int
@export_flags_2d_physics var fire_layer: int
@export_flags_2d_physics var fake_layer: int
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


var default_direction := Vector2.DOWN 
var post_index: int = 0:
	set(value):
		post_index = wrapi(value, 0, post_positions.size())

var target: Vector2:
	set(value):
		target = value.round()
var target_direction: Vector2
var target_type: TargetType

var can_teleport := false

var end_level := false


func _ready():
	GameManager.connect("game_turn", _on_game_turn)
	
	if post_positions.is_empty():
		post_positions.append(global_position)
	
	position = post_positions[0]
	post_index += 1
	target = post_positions[post_index]
	
	set_animation_direction(default_direction)
	set_raycasts(default_direction)


func _on_game_turn(turn_time: float):
	target_direction = target - position
	
	var animation_suffix := animation.get_slice("_", 1)
	var tween: Tween = create_tween()
	if can_teleport:
		can_teleport = false
		tween.tween_property(self, "modulate", Color.TRANSPARENT, turn_time * 0.5)
		tween.tween_property(self, "modulate", Color.WHITE, turn_time * 0.5)
		await tween.step_finished
		
		position = target
		var face_direction := default_direction
		if post_positions.size() > 1:
			post_index += 1
			face_direction = target.direction_to(post_positions[post_index])
			post_index -= 1
		
		set_animation_direction(face_direction, "calm")
		set_raycasts(face_direction)
	elif target_direction != Vector2.ZERO:
		target_direction = target_direction.normalized()
		tween.tween_property(self, "position", target_direction * 16, turn_time)\
		.as_relative()
		
		set_animation_direction(target_direction, animation_suffix)
		set_raycasts(target_direction)
	else:
		tween.tween_interval(turn_time)
	
	await tween.finished
	await get_tree().process_frame
	position = position.round()
	
	if position == target and target_type == TargetType.FIRE:
		for raycast in raycasts:
			var collider = raycast.get_collider()
			if not collider is TileMap and collider.collision_layer == fire_layer\
			and position.distance_squared_to(raycast.get_collision_point()) < 256:
				collider.put_out()
	
	if end_level:
		AudioManager.die_audio.play()
		get_tree().reload_current_scene() # Reset Level
	
	set_target()
	
	# Animation mad to calm or calm to mad
	var animation_prefix := animation.get_slice("_", 0)
	animation_suffix = "calm" if target_type == TargetType.POST else "mad"
	play(animation_prefix + "_" + animation_suffix)


func set_target():
	if position == target:
		if target_type == TargetType.POST:
			post_index += 1
		else:
			post_index -= 1
			can_teleport = true
		target_type = TargetType.POST
	
	for raycast in raycasts:
		var collider: Node2D = raycast.get_collider()
		if !collider or collider is TileMap \
				or [door_layer, pit_layer, fake_layer].count(collider.collision_layer):
			continue
		elif collider.collision_layer == fire_layer:
			target = collider.global_position - 16 * raycast.target_position.normalized()
			target_type = TargetType.FIRE
			continue
		
		# Sees Player
		target = collider.global_position
		target_type = TargetType.PLAYER
	
	if target_type == TargetType.POST:
		target = post_positions[post_index]
	else:
		can_teleport = false


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
