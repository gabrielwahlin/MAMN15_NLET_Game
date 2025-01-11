extends Node2D

@onready var transition = $AnimationPlayer
@onready var pause_menu = $PauseMenu
var paused = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transition.play("fade_in")
	
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
		
func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 1
		
	paused = !paused
