extends PathFollow2D

@onready var line_edit = $"../CanvasLayer2/LineEdit"
@onready var win_label = $"../CanvasLayer2/WinPopup/Label"
@onready var win_popup_panel = $"../CanvasLayer2/WinPopup/"
@onready var new_game_button = win_popup_panel.get_node("Button")
@onready var popup_panel = $"../CanvasLayer2/Popup"
@onready var try_again_button = popup_panel.get_node("Button")
@onready var start_pointer_hor = $"../../StartPointerHor"
@onready var end_pointer_hor = $"../../EndPointerHor"
@onready var start_pointer_ver = $"../../StartPointerVer"
@onready var end_pointer_ver = $"../../EndPointerVer"
@onready var horizontal_path = $"../../HorizontalPath"
@onready var vertical_path = $"../../VerticalPath"
@onready var rep = $"../rep"
@onready var hor_path_follow = $"../../HorizontalPath/HorPathFollow"
@onready var mus_vert = $"../../VerticalPath/VerPathFollow/Sprite2D"
@onready var celebration = $"../../celebr"

var target_ratio: float = 0.0
var smooth_speed: float = 1.0
var rng = RandomNumberGenerator.new()
var targetnumber_ver: float = 0.0
var play_ani: bool = false
var value_entered: bool = false
var is_moving: bool = false
var elapsed_time_ver: float = 0.0
var time_ver_flag: bool = false
var celebration_flag: bool = false

# Round function to limit decimals
func round_to(value: float, decimals: int) -> float:
	var factor = pow(10, decimals)
	return round(value * factor) / factor

# Corrected _ready function
func _ready():
	targetnumber_ver = hor_path_follow.targetnumber_ver
	print("Target number vertical is:", targetnumber_ver)
	
	# Ensure other nodes are initialized
	if line_edit == null:
		print("Error: LineEdit node not found.")
	else:
		line_edit.text_submitted.connect(_on_text_submitted)
	
	if win_popup_panel != null:
		win_popup_panel.visible = false
	
	if popup_panel != null:
		popup_panel.visible = false  # Hide the popup initially
	
	if try_again_button != null:
		try_again_button.pressed.connect(reset_scene)

	if new_game_button != null:
		new_game_button.pressed.connect(reset_scene)
# Function to handle input submission
func _on_text_submitted(text: String) -> void:
	if text.is_valid_float():
		var input_number = int(text)
		if input_number >= 0 and input_number <= 100:
			target_ratio = round_to(input_number / 100.0, 2)
			if time_ver_flag != true:
				print("Elapsed Time: " + str(elapsed_time_ver - hor_path_follow.elapsed_time_hor) + " seconds")
				time_ver_flag = true
			line_edit.editable = false
			value_entered = true
			is_moving = true
			print("New target progress_ratio:", target_ratio)
		else:
			print("Invalid input: Enter a number between 0 and 100.")
			show_popup()
	else:
		print("Invalid input: Please enter a valid number.")
		show_popup()

	line_edit.clear()

# The main game loop
func _process(delta: float) -> void:
	if not play_ani:
		mus_vert.play("idle")
	# Smoothly update the progress ratio only when the player input is valid
	elapsed_time_ver += delta
	if progress_ratio < target_ratio:
		progress_ratio = progress_ratio + smooth_speed * delta
	# Check if the target has been reached and update UI accordingly
	if value_entered and (targetnumber_ver - progress_ratio) > 0.01 and not play_ani: 
			play_ani = true
			mus_vert.play("new_animation")
	elif abs(target_ratio - progress_ratio) < 0.05 and value_entered:
		if not celebration_flag:
			mus_vert.stop()
		
		
	# Check if the target has been reached and update UI accordingly
	if value_entered and not mus_vert.is_playing():
		if abs(targetnumber_ver - target_ratio) <= 0.051:
			if not celebration.is_playing():
				celebration.play()
			mus_vert.play("dancing")
			celebration_flag = true
			correct_ver()
			popup_panel.visible = false
			is_moving = false
		else:
			is_moving = false
			if popup_panel != null and not popup_panel.visible:
				show_popup(
					"Ajajaj, du gissade: "
					+ str(target_ratio*100)
					+ " Rätt svar är: "
					+ str(targetnumber_ver * 100)
				)
	else:
		#is_moving = false
		if popup_panel != null and popup_panel.visible:
			popup_panel.visible = false


# Function to handle the correct vertical path condition
func correct_ver():
	win_label.visible = true

	win_popup_panel.visible = true
	#print("Correct vertical path reached!")

# Function to show popup for invalid input
func show_popup(message: String = "Unfortunately, this was wrong. Please try again!"):
	if popup_panel != null:
		popup_panel.visible = true
		var label = popup_panel.get_node("Label") # Adjust this path if necessary
		if label != null:
			label.text = message
			print("Popup displayed with message:", message)

# Function to reset the scene
func reset_scene() -> void:
	get_tree().reload_current_scene()
