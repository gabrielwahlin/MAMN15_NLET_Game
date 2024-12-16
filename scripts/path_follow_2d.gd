extends PathFollow2D

@onready var line_edit = $"../CanvasLayer/LineEdit"  # Adjust the path to the LineEdit node
@onready var win_label = $"../CanvasLayer/Label"    # Adjust the path to the Label node

var target_ratio: float = 0.0
var smooth_speed: float = 2.0

# Helper function to round a number to a specified number of decimal places
func round_to(value: float, decimals: int) -> float:
	var factor = pow(10, decimals)
	return round(value * factor) / factor

func _ready():
	if line_edit == null:
		print("Error: LineEdit node not found.")
	else:
		line_edit.text_submitted.connect(_on_text_submitted)
		
	if win_label != null:
		win_label.visible = false

func _on_text_submitted(text: String) -> void:
	if text.is_valid_float():
		var input_number = int(text)
		if input_number >= 0 and input_number <= 9:
			target_ratio = input_number / 10.0
			print("New target progress_ratio:", target_ratio)
		else:
			print("Invalid input: Enter a number between 0 and 9.")
	else:
		print("Invalid input: Please enter a valid number.")

	line_edit.clear()

func _process(delta: float) -> void:
	# Smoothly update progress_ratio and round it to 3 decimal places
	progress_ratio = round_to(lerp(progress_ratio, target_ratio, smooth_speed * delta), 3)
	#print(progress_ratio)

	if progress_ratio == 0.8:
		display_win_message()

func display_win_message():
	win_label.visible = true
