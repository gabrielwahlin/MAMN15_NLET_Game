extends Control

@onready var game = $"../"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_pressed() -> void:
	game.pauseMenu()

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://StartMenu.tscn")
