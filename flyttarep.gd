extends Sprite2D

# Range for random horizontal position
const MIN_X_POSITION = 200.0
const MAX_X_POSITION = 1500.0

@onready var verpath: Path2D = $VerticalPath
@onready var path_follow: PathFollow2D = $VerticalPath/VerPathFollow
@onready var second_sprite: Sprite2D = $"VerticalPath/VerPathFollow/Sprite2D"  # Reference the second sprite

func _ready() -> void:
	randomize()

	# Validate nodes
	if not verpath or not path_follow or not second_sprite:
		push_error("Path2D, PathFollow2D, or SecondSprite node is missing!")
		return

	print("Path2D, PathFollow2D, and SecondSprite nodes found and assigned.")

	# Generate a random horizontal position
	var random_x = randf_range(MIN_X_POSITION, MAX_X_POSITION)
	#position.x = random_x
	verpath.position.x = random_x

	# Align PathFollow2D with the first sprite
	path_follow.position.x = verpath.position.x

	# Initialize the second sprite's position
	update_second_sprite_position()

func _process(delta: float) -> void:
	# Continuously update the second sprite's position to follow the path
	update_second_sprite_position()

func update_second_sprite_position() -> void:
	# Set the second sprite's position to match the PathFollow2D's position
	second_sprite.position = path_follow.global_position
