extends Area2D


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var fire_audio: AudioStreamPlayer2D = $FireAudio
@onready var ignite_audio: AudioStreamPlayer2D = $IgniteAudio
@onready var dowse_audio: AudioStreamPlayer2D = $DowseAudio

@export var is_lit := false
@export_flags_2d_physics var unlit_layer := 32
@export_flags_2d_physics var lit_layer := 64


func _ready():
	if is_lit:
		ignite()


func ignite():
	is_lit = true
	collision_layer = lit_layer
	sprite.play("lit")
	ignite_audio.play()
	fire_audio.play()


func put_out():
	is_lit = false
	collision_layer = unlit_layer
	sprite.play("unlit")
	dowse_audio.play()
	fire_audio.stop()
