extends Sprite2D

# Range for random horizontal position (can adjust these as needed)
const MIN_X_POSITION = -300.0  # Set to the desired min value
const MAX_X_POSITION = 300.0   # Set to the desired max value

@onready var path: Path2D = %VerPathFollow  # Path2D node as a child of the sprite

func _ready() -> void:
	# Randomize the horizontal position within the specified range.
	var random_x = randf_range(MIN_X_POSITION, MAX_X_POSITION)
	
	# Set the sprite's position and the path's position to the same random X value
	position.x = random_x
	path.position.x = random_x  # Align the path with the sprite horizontally
	
	# Optionally, you can randomize the starting position on the path, but it's not necessary in this case
	# path_follow.offset = randf_range(0.0, 1.0)  # Uncomment to randomize the path offset
