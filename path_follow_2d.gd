extends PathFollow2D

@onready var line_edit = $"../CanvasLayer/LineEdit"
@onready var win_label = $"../CanvasLayer/Label"
@onready var popup_panel = $"../CanvasLayer/Popup" # Reference to the popup
@onready var start_pointer_hor = $"/root/Game/StartPointerHor"
@onready var try_again_button = popup_panel.get_node("Button")
@onready var end_pointer_hor = $"/root/Game/EndPointerHor"
@onready var start_pointer_ver = $"/root/Game/StartPointerVer"
@onready var end_pointer_ver = $"/root/Game/EndPointerVer"
@onready var horizontal_path = $"/root/Game/HorizontalPath" # Reference to HorizontalPath
@onready var vertical_path = $"/root/Game/VerticalPath" # Reference to VerticalPath
@onready var line_edit_ver = $"/root/Game/VerticalPath/CanvasLayer2/LineEdit"
@onready var spritever = $"/root/Game/VerticalPath/VerPathFollow/Sprite2D"

var target_ratio: float = 0.0
var smooth_speed: float = 1.0
var rng = RandomNumberGenerator.new()
var targetnumber_hor: float = 0.0
var value_entered: bool = false # Track if a value has been entered

func round_to(value: float, decimals: int) -> float:
	var factor = pow(10, decimals)
	return round(value * factor) / factor

func _ready():
	targetnumber_hor = round_to(rng.randf_range(0.1, 0.9), 3)
	print("Target number horizontal is:", targetnumber_hor)

	if line_edit == null:
		print("Error: LineEdit node not found.")
	else:
		line_edit.text_submitted.connect(_on_text_submitted)

	if win_label != null:
		win_label.visible = false

	if try_again_button != null:
		try_again_button.pressed.connect(reset_scene)

func _on_text_submitted(text: String) -> void:
	if text.is_valid_float():
		var input_number = int(text)
		if input_number >= 0 and input_number <= 9:
			target_ratio = round_to(input_number / 10.0, 3)
			line_edit.editable = false
			value_entered = true # Mark that a value has been entered
			print("New target progress_ratio:", target_ratio)
		else:
			print("Invalid input: Enter a number between 0 and 9.")
			show_popup() # Show popup immediately for invalid input
	else:
		print("Invalid input: Please enter a valid number.")
		show_popup() # Show popup immediately for invalid input

	line_edit.clear()

func _process(delta: float) -> void:
	progress_ratio = round_to(lerp(progress_ratio, target_ratio, 1.0 - pow(0.01, smooth_speed * delta)), 3)

# Only show the popup if the sprite is not in the correct range and input is invalid
	if value_entered:
		if abs(progress_ratio - targetnumber_hor) < 0.07 and abs(progress_ratio - target_ratio) < 0.07: # The sprite is within the correct range and stopped
			correct_hor()
		else:
			if not popup_panel.visible: # Show the popup only if it is not already visible
				show_popup() # Optionally show a message that the value is not correct yet
	else:
# If no value is entered yet, hide the popup unless needed
		if popup_panel != null and popup_panel.visible:
			popup_panel.visible = false # Hide the popup by default until an invalid input occurs.


func show_popup():
	if popup_panel != null:
		popup_panel.visible = true
		popup_panel.get_node("Label").text = "Unfortunately, this was wrong. Please try again!"
		print("Popup displayed: Incorrect value entered.")


func correct_hor():
# Ensure the pop-up is hidden when the correct value is entered
	if popup_panel.visible:
		popup_panel.visible = false

# Hide horizontal pointers and show vertical pointers
	if abs(progress_ratio - targetnumber_hor) < 0.07:
		start_pointer_hor.visible = false
		end_pointer_hor.visible = false
		start_pointer_ver.visible = true
		end_pointer_ver.visible = true

# Reparent this PathFollow2D to the VerticalPath
	var parent_path = get_parent()
	if parent_path == horizontal_path and vertical_path != null:
		parent_path.remove_child(self)
		vertical_path.visible = true
		line_edit.visible = false
		line_edit_ver.visible = true
		spritever.visible = true
		print("Switched to VerticalPath!")
	else:
		print("Not within the correct range yet. Waiting for the correct position.")

func reset_scene() -> void:
	get_tree().reload_current_scene()
