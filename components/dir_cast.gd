@tool
class_name DirCast
extends Node2D


@onready var cast_dict = {Vector2.DOWN: $DownCast, Vector2.RIGHT: $RightCast, 
						  Vector2.LEFT: $LeftCast, Vector2.UP: $UpCast}

@export var right_length := 16:
	get:
		return $RightCast.target_position.x
	set(value):
		right_length = value
		$RightCast.target_position = Vector2.RIGHT * value

@export var down_length := 16:
	get:
		return $DownCast.target_position.y
	set(value):
		down_length = value
		$DownCast.target_position = Vector2.DOWN * value

@export var left_length := 16:
	get:
		return -$LeftCast.target_position.x
	set(value):
		left_length = value
		$LeftCast.target_position = Vector2.LEFT * value

@export var up_length := 16:
	get:
		return -$UpCast.target_position.y
	set(value):
		up_length = value
		$UpCast.target_position = Vector2.UP * value

@export_flags_2d_physics var collision_mask := 0:
	set(value):
		collision_mask = value
		$DownCast.collision_mask = value
		$RightCast.collision_mask = value
		$LeftCast.collision_mask = value
		$UpCast.collision_mask = value

@export var collide_with_areas := false:
	set(value):
		collide_with_areas = value
		$RightCast.collide_with_areas = value
		$DownCast.collide_with_areas = value
		$LeftCast.collide_with_areas = value
		$UpCast.collide_with_areas = value

@export var collide_with_bodies := true:
	set(value):
		collide_with_bodies = value
		$RightCast.collide_with_bodies = value
		$DownCast.collide_with_bodies = value
		$LeftCast.collide_with_bodies = value
		$UpCast.collide_with_bodies = value


func is_colliding(direction: Vector2) -> bool:
	return cast_dict[direction].is_colliding()


func get_colliding_directions() -> Array[Vector2]:
	var colliding_directions: Array[Vector2] = []
	
	for direction in cast_dict.keys():
		if is_colliding(direction):
			colliding_directions.append(direction)
	
	return colliding_directions


func get_collision_length(direction: Vector2) -> float:
	var point: Vector2 = cast_dict[direction].get_collision_point()
	point = Vector2.ZERO if point == Vector2.ZERO else point - global_position
	if direction.y == 0:
		return absf(point.x)
	return absf(point.y)


func get_collision_bounds() -> Dictionary:
	var collision_bounds := {}
	for direction in cast_dict.keys():
		collision_bounds[direction] = get_collision_length(direction)
	return collision_bounds


func get_dir_collider(direction: Vector2) -> Object:
	return cast_dict[direction].get_collider()
