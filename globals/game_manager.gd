extends Node


signal game_turn(turn_time)


@onready var levels: Array[String] = [
	"res://levels/level_1.tscn", 
	"res://levels/knights_move.tscn",
	"res://levels/knight_cycles.tscn",
	"res://levels/level_fire_pit.tscn", 
	"res://levels/level_key_door.tscn",
	"res://levels/level_with_some_fake_walls.tscn",
	"res://levels/level__with_fire_quirk.tscn",
	]

var turn_time: float = 0.5
var level_id: int = 0:
	set(value):
		level_id = value
		if value > farthest_level:
			farthest_level = value
var farthest_level: int = 0


func load_level(load_level_id):
	level_id = load_level_id
	var level = load(levels[level_id]).instantiate()
	get_tree().root.add_child(level)


func load_next_level(current_level: Object):
	level_id += 1
	
	if level_id >= levels.size():
		level_id = 0
	
	var next_level = load(levels[level_id]).instantiate()
	
	get_tree().root.add_child(next_level)
	current_level.queue_free()
