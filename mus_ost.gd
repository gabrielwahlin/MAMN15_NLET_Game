extends PathFollow2D

@onready var musfan = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	musfan.play("walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await get_tree().create_timer(0.25).timeout
	progress_ratio +=  0.25 * delta
	if progress_ratio > 0.95:
		musfan.stop()
	if progress_ratio == 1:
		await get_tree().create_timer(0.5).timeout
		musfan.play("flip")
