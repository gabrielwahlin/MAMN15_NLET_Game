extends Control

@onready var transitions = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spatial_pressed() -> void:
	#get_tree().change_scene_to_file("res://game.tscn")
	transitions.play("fade_out")
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://game.tscn")
