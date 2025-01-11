extends AnimatedSprite2D

@onready var mouse = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse.animation = "idle"
	mouse.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
