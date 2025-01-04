extends PathFollow2D

@onready var line_edit = $"../CanvasLayer/LineEdit"  # Adjust the path to the LineEdit node
@onready var win_label = $"../CanvasLayer/Label"    # Adjust the path to the Label node
@onready var start_pointer_hor = $"/root/Game/StartPointerHor"
@onready var end_pointer_hor = $"/root/Game/EndPointerHor"
@onready var start_pointer_ver = $"/root/Game/StartPointerVer"
@onready var end_pointer_ver = $"/root/Game/EndPointerVer"

var target_ratio: float = 0.0
var smooth_speed: float = 1.0
var rng = RandomNumberGenerator.new()
var targetnumber: float = 0.0  # Declare targetnumber as a member variable

# Helper function to round a number to a specified number of decimal places
func round_to(value: float, decimals: int) -> float:
	var factor = pow(10, decimals)
	return round(value * factor) / factor

func _ready():
	# Generate a random target number between 0.1 and 0.9
	targetnumber = round_to(rng.randf_range(0.1, 0.9), 3)
	print("Target number is:", targetnumber)
	
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
			target_ratio = round_to(input_number / 10.0, 3)
			line_edit.editable = false
			print("New target progress_ratio:", target_ratio)
		else:
			print("Invalid input: Enter a number between 0 and 9.")
	else:
		print("Invalid input: Please enter a valid number.")

	line_edit.clear()

func _process(delta: float) -> void:
	# Smoothly update progress_ratio and round it to 3 decimal places
	progress_ratio = round_to(lerp(progress_ratio, target_ratio, 1.0 - pow(0.01, smooth_speed * delta)), 3)

	print("Progress ratio:", progress_ratio)

	# Check if progress_ratio is close enough to targetnumber
	if abs(progress_ratio - targetnumber) < 0.07:
		display_win_message()
	else:
		display_win_message_oob()

func display_win_message():
	win_label.visible = true
	start_pointer_hor.visible = false
	end_pointer_hor.visible = false
	start_pointer_ver.visible = true
	end_pointer_ver.visible = true
	
func display_win_message_oob():
	win_label.visible = false
	start_pointer_hor.visible = true
	end_pointer_hor.visible = true
	start_pointer_ver.visible = false
	end_pointer_ver.visible = false
