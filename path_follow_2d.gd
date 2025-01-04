extends PathFollow2D

@onready var line_edit = $"../CanvasLayer/LineEdit"
@onready var win_label = $"../CanvasLayer/Label"
@onready var start_pointer_hor = $"/root/Game/StartPointerHor"
@onready var end_pointer_hor = $"/root/Game/EndPointerHor"
@onready var start_pointer_ver = $"/root/Game/StartPointerVer"
@onready var end_pointer_ver = $"/root/Game/EndPointerVer"
@onready var horizontal_path = $"/root/Game/HorizontalPath"  # Reference to HorizontalPath
@onready var vertical_path = $"/root/Game/VerticalPath"      # Reference to VerticalPath

var target_ratio: float = 0.0
var smooth_speed: float = 1.0
var rng = RandomNumberGenerator.new()
var targetnumber_hor: float = 0.0

func round_to(value: float, decimals: int) -> float:
	var factor = pow(10, decimals)
	return round(value * factor) / factor

func _ready():
	targetnumber_hor = round_to(rng.randf_range(0.1, 0.9), 3)
	print("Target number is:", targetnumber_hor)

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
	progress_ratio = round_to(lerp(progress_ratio, target_ratio, 1.0 - pow(0.01, smooth_speed * delta)), 3)

	if abs(progress_ratio - targetnumber_hor) < 0.07:
		correct_hor()

func correct_hor():
	line_edit.editable = true

	# Hide horizontal pointers and show vertical pointers
	start_pointer_hor.visible = false
	end_pointer_hor.visible = false
	start_pointer_ver.visible = true
	end_pointer_ver.visible = true

	# Reparent this PathFollow2D to the VerticalPath
	var parent_path = get_parent()
	if parent_path == horizontal_path and vertical_path != null:
		parent_path.remove_child(self)
		vertical_path.add_child(self)
		progress_ratio = 0.0  # Reset to the beginning of the new path
		print("Switched to VerticalPath!")
