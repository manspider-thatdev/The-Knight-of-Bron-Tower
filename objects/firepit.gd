extends Area2D


@onready var sprite = $AnimatedSprite2D

@export var is_lit := false
@export_flags_2d_physics var unlit_layer = 32
@export_flags_2d_physics var lit_layer = 64


func ignite():
	is_lit = true
	collision_layer = lit_layer
	sprite.play("lit")


func put_out():
	is_lit = false
	collision_layer = unlit_layer
	sprite.play("unlit")
