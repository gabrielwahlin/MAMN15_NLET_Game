extends Sprite2D

# Range for random horizontal position (can adjust these as needed)
const MIN_X_POSITION = 1000.0  # Set to the desired min value
const MAX_X_POSITION = 1500.0   # Set to the desired max value

@onready var path: Path2D = %VerticalPath  # Path2D node as a child of the sprite
@onready var path_follow: PathFollow2D = %VerPathFollow  # PathFollow2D is a child of Path2D

func _ready() -> void:
	# Check if path and path_follow are properly assigned
	if path and path_follow:
		print("Path2D and PathFollow2D nodes found and assigned.")
	else:
		print("Path2D or PathFollow2D node not found!")

	# Randomize the horizontal position within the specified range.
	var random_x = randf_range(MIN_X_POSITION, MAX_X_POSITION)

	# Set the sprite's position
	position.x = random_x

	# Move the path horizontally to match the sprite
	path.position.x = random_x
