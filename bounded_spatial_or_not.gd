extends Control

@onready var transition = $AnimationPlayer
@onready var mouse = $AnimatedSprite2D
@onready var text_anim = $TitleText/AnimationPlayer


var target_scene: String = ""

func _ready() -> void:
	mouse.play()
	text_anim.play("titleText")

func _process(delta: float) -> void:
	pass

func _on_spatial_pressed() -> void:
	target_scene = "res://game.tscn"
	transition.play("fade_out")

func _on_no_spatial_pressed() -> void:
	target_scene = "res://bounded_no_spatial.tscn"
	transition.play("fade_out")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		get_tree().change_scene_to_file(target_scene)
