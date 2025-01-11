extends Control

@onready var transition = $AnimationPlayer
@onready var mouse = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#mouse.animation("idle")
	mouse.play() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://bounded_spatial_or_not.tscn")
	#transition.play("fade_out")
	


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://unbounded_spatial_or_not.tscn")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://bounded_spatial_or_not.tscn")


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://tutorial.tscn") # Replace with function body.
