extends Node


signal game_turn(turn_time)


var save_path := "user://save_data.save"

@onready var levels: Array[String] = [
	"res://levels/level_1.tscn", 					# 1
	"res://levels/knight_wing.tscn",				# 2
	"res://levels/knights_move.tscn",				# 3
	"res://levels/level_key_door.tscn",				# 4
	"res://levels/knight_patrol.tscn",				# 5
	"res://levels/level_with_some_fake_walls.tscn",	# 6
	"res://levels/level_fire_pit.tscn", 			# 7
	"res://levels/in_the_walls.tscn",				# 8
	"res://levels/knight_cycles.tscn",				# 9
	"res://levels/knight_knight_knight.tscn",		# 10
	"res://levels/double_duty.tscn",				# 11
	"res://levels/level__with_fire_quirk.tscn",		# 12
	"res://levels/knight_watch.tscn",				# 13
	"res://levels/midknight_snack.tscn",			# 14
	"res://levels/epic_level.tscn",					# 15
	]

var turn_time: float = 0.37
var level_id: int = 0:
	set(value):
		level_id = value
		if value > farthest_level:
			farthest_level = value
			save()
var farthest_level: int = 0


func _ready():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		farthest_level = file.get_var(farthest_level)


func load_level(load_level_id):
	level_id = load_level_id
	ScreenTransition.change_scene(levels[level_id])


func load_next_level():
	level_id += 1
	
	if level_id >= levels.size():
		level_id = 0
		ScreenTransition.change_scene("res://ui/credits_menu.tscn")
	else:
		ScreenTransition.change_scene(levels[level_id])


func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(farthest_level)
