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
	target_scene = "res://unbounded_spatial.tscn"
	#get_tree().change_scene_to_file(target_scene)
	transition.play("fade_out")

func _on_no_spatial_pressed() -> void:
	target_scene = "res://unbounded_no_spatial.tscn"
	#get_tree().change_scene_to_file(target_scene)
	transition.play("fade_out")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		get_tree().change_scene_to_file(target_scene)


func _on_animated_sprite_2d_animation_finished() -> void:
	pass # Replace with function body.


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://StartMenu.tscn") # Replace with function body.
