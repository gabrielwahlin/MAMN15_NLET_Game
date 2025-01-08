extends PathFollow2D

@onready var line_edit = $"../CanvasLayer2/LineEdit"
@onready var win_label = $"../CanvasLayer2/Label"
@onready var popup_panel = $"../CanvasLayer2/Popup"  # Reference to the popup
@onready var try_again_button = popup_panel.get_node("Button")  # Button inside the popup
@onready var start_pointer_hor = $"/root/Game/StartPointerHor"
@onready var end_pointer_hor = $"/root/Game/EndPointerHor"
@onready var start_pointer_ver = $"/root/Game/StartPointerVer"
@onready var end_pointer_ver = $"/root/Game/EndPointerVer"
@onready var horizontal_path = $"/root/Game/HorizontalPath"
@onready var vertical_path = $"/root/Game/VerticalPath"

var target_ratio: float = 0.0
var smooth_speed: float = 1.0
var rng = RandomNumberGenerator.new()
var targetnumber_ver: float = 0.0
var value_entered: bool = false  # Flag to track if a value has been entered

func round_to(value: float, decimals: int) -> float:
	var factor = pow(10, decimals)
	return round(value * factor) / factor

func _ready():
	targetnumber_ver = round_to(rng.randf_range(0.1, 0.9), 3)
	print("Target number vertical is:", targetnumber_ver)

	
	if line_edit == null:
		print("Error: LineEdit node not found.")
	else:
		line_edit.text_submitted.connect(_on_text_submitted)
		
	if win_label != null:
		win_label.visible = false
	
	if popup_panel != null:
		popup_panel.visible = false  # Hide the popup initially
	
	if try_again_button != null:
		try_again_button.pressed.connect(reset_scene)

func _on_text_submitted(text: String) -> void:
	if text.is_valid_float():
		var input_number = int(text)
		if input_number >= 0 and input_number <= 9:
			target_ratio = round_to(input_number / 10.0, 3)
			line_edit.editable = false
			value_entered = true  # Set the flag to true
			print("New target progress_ratio:", target_ratio)
		else:
			print("Invalid input: Enter a number between 0 and 9.")
	else:
		print("Invalid input: Please enter a valid number.")

	line_edit.clear()

func _process(delta: float) -> void:
	progress_ratio = round_to(lerp(progress_ratio, target_ratio, 1.0 - pow(0.01, smooth_speed * delta)), 3)

	if value_entered:
		if abs(progress_ratio - targetnumber_ver) < 0.07:
			correct_ver()
		elif not popup_panel.visible:  # Show the popup only once
			show_popup()

func correct_ver():
	win_label.visible = true

func show_popup():
	if popup_panel != null:
		popup_panel.visible = true
		
		popup_panel.get_node("Label").text = "Unfortunately, this was wrong. Please try again!"
		print("Popup displayed: Incorrect value entered.")

func reset_scene() -> void:
	get_tree().reload_current_scene()
