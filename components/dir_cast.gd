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


func get_collision_length(direction: Vector2) -> float:
	var point = cast_dict[direction].get_collision_point() - global_position
	if direction.y == 0:
		return abs(point.x)
	return abs(point.y)


func get_collision_bounds() -> Dictionary:
	return {Vector2.RIGHT: get_collision_length(Vector2.RIGHT),\
			Vector2.DOWN: get_collision_length(Vector2.DOWN),\
			Vector2.LEFT: get_collision_length(Vector2.LEFT),\
			Vector2.UP: get_collision_length(Vector2.UP)}
