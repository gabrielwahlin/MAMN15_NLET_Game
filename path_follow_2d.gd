extends PathFollow2D

@onready var line_edit = $"../CanvasLayer/LineEdit"
@onready var win_label = $"../CanvasLayer/Label"
@onready var popup_panel = $"../CanvasLayer/Popup"
@onready var start_pointer_hor = $"/root/Game/StartPointerHor"
@onready var start_number_hor = $"/root/Game/StartPointerHor/StartNumberHor"
@onready var end_number_hor = $"/root/Game/EndPointerHor/EndNumberHor"
@onready var start_number_ver = $"/root/Game/StartPointerVer/StartNumberVer"
@onready var end_number_ver = $"/root/Game/EndPointerVer/EndNumberVer"
@onready var try_again_button = popup_panel.get_node("Button")
@onready var end_pointer_hor = $"/root/Game/EndPointerHor"
@onready var start_pointer_ver = $"/root/Game/StartPointerVer"
@onready var end_pointer_ver = $"/root/Game/EndPointerVer"
@onready var horizontal_path = $"/root/Game/HorizontalPath"
@onready var vertical_path = $"/root/Game/VerticalPath"
@onready var line_edit_ver = $"/root/Game/VerticalPath/CanvasLayer2/LineEdit"
@onready var spritever = $"/root/Game/VerticalPath/VerPathFollow/Sprite2D"
@onready var rep = $/root/Game/VerticalPath/rep
@onready var mus = $/root/Game/HorizontalPath/HorPathFollow/Sprite2D
@onready var mus_vert = $/root/Game/VerticalPath/VerPathFollow/Sprite2D
@onready var ost = $/root/Game/VerticalPath/ost
@onready var ver_path_follow = $"/root/Game/VerticalPath/VerPathFollow"
@onready var spiky1 = $/root/Game/spikar/Spiky
@onready var spiky2 = $/root/Game/spikar/Spiky2
@onready var spiky3 = $/root/Game/spikar/Spiky3

var target_ratio: float = 0.0
var smooth_speed: float = 1.0
var rng = RandomNumberGenerator.new()
var targetnumber_hor: float = 0.0
var targetnumber_ver: float = 0.0
var value_entered: bool = false
var is_moving: bool = false  # Track whether movement should happen

# Round function to limit decimals
func round_to(value: float, decimals: int) -> float:
	var factor = pow(10, decimals)
	return round(value * factor) / factor

# Initialization of the paths, sprites, and numbers
func _ready():
	targetnumber_hor = round_to(rng.randf_range(0.0, 1.0), 2)
	targetnumber_ver = round_to(rng.randf_range(0.0, 1.0), 2)
	# Set the positions of elements on the horizontal and vertical paths
	rep.position.x = targetnumber_hor * 835 - 1225
	mus_vert.position.y = targetnumber_hor * 835 - 1040
	ost.position.x = targetnumber_hor * 835 - 1225
	ost.position.y = targetnumber_ver * -800 + 815
	end_pointer_ver.position.x = targetnumber_hor * 750 + 575
	start_pointer_ver.position.x = targetnumber_hor * 750 + 575
	
	# Set positions of spiky obstacles
	spiky1.global_position.x = rep.global_position.x + 60
	spiky2.global_position.x = rep.global_position.x + 60
	spiky3.global_position.x = rep.global_position.x + 60

	print("Target number horizontal is:", targetnumber_hor)

	# Initialize nodes and connections
	if line_edit == null:
		print("Error: LineEdit node not found.")
	else:
		line_edit.text_submitted.connect(_on_text_submitted)

	if win_label != null:
		win_label.visible = false

	if try_again_button != null:
		try_again_button.pressed.connect(reset_scene)

	# Set up the AnimatedSprite2D
	mus.animation = "new_animation"  # Replace with the name of your animation in SpriteFrames
	mus.play()  # Start animation
	mus_vert.animation = "new_animation"
	mus_vert.play()

# Function to handle input submission
func _on_text_submitted(text: String) -> void:
	if text.is_valid_float():
		var input_number = int(text)
		if input_number >= 0 and input_number <= 100:
			target_ratio = round_to((input_number + 5) / 100.0, 2)

			line_edit.editable = false
			value_entered = true
			is_moving = true  # Start moving after valid input
			print("New target progress_ratio:", target_ratio)
		else:
			print("Invalid input: Enter a number between 0 and 9.")
			show_popup()
	else:
		print("Invalid input: Please enter a valid number.")
		show_popup()

	line_edit.clear()

# The main game loop
func _process(delta: float) -> void:
	# Smoothly update the progress ratio only when the player input is valid
	if is_moving:
		progress_ratio = clamp(progress_ratio + smooth_speed * delta, 0.0, 1.0)
 # Constant speed movement towards target

	# Check if the target has been reached and update UI accordingly
	if value_entered:
		if abs(progress_ratio - targetnumber_hor) < 0.05 and abs(progress_ratio - target_ratio) < 0.05:
			correct_hor()
			popup_panel.visible = false
			is_moving = false  # Stop moving once the target is reached
		elif abs(progress_ratio - target_ratio) < 0.05:
			is_moving = false
			if popup_panel != null and not popup_panel.visible:
				show_popup(
					"Ajajaj, du gissade: "
					+ str(round(progress_ratio * 100))
					+ " Rätt svar är: "
					+ str(targetnumber_hor * 100)
				)
		elif abs(progress_ratio - 1.0) <= 0.01 and target_ratio == 1.05:
			# Special case for maximum value (100)
			is_moving = false
			if popup_panel != null and not popup_panel.visible:
				show_popup("Ajajaj, du gissade 100! Rätt svar är: " + str(targetnumber_hor * 100))
	else:
		#is_moving = false
		if popup_panel != null and popup_panel.visible:
			popup_panel.visible = false

	# Horizontal animation logic
	if abs(progress_ratio - target_ratio) > 0.01:  # If moving horizontally
		if not mus.is_playing():
			mus.play("new_animation")
	else:
		mus.stop()  # Stop the horizontal animation when the target is reached

	# Vertical animation logic
	if vertical_path.visible:  # Check if we're on the vertical path
		if abs(progress_ratio - target_ratio) > 0.01:  # If moving vertically
			if not mus_vert.is_playing():
				mus_vert.play("new_animation")
		else:
			mus_vert.stop()  # Stop the vertical animation when the target is reached

# Function to show popup for invalid input
func show_popup(message: String = "Unfortunately, this was wrong. Please try again!"):
	if popup_panel != null:
		popup_panel.visible = true
		var label = popup_panel.get_node("Label") # Adjust this path if necessary
		if label != null:
			label.text = message
			print("Popup displayed with message:", message)

# Function to handle the correct horizontal path condition
func correct_hor():
	if popup_panel.visible:
		popup_panel.visible = false

	if abs(progress_ratio - targetnumber_hor) < 0.07:
		# Hide the horizontal pointers and numbers
		start_pointer_hor.visible = false
		end_pointer_hor.visible = false
		start_number_hor.visible = false
		end_number_hor.visible = false
		
		# Show the vertical path pointers and numbers
		start_pointer_ver.visible = true
		end_pointer_ver.visible = true
		start_number_ver.visible = true
		end_number_ver.visible = true

	# Switch to vertical path
	var parent_path = get_parent()
	if parent_path == horizontal_path and vertical_path != null:
		parent_path.remove_child(self)  # Remove horizontal path node
		vertical_path.visible = true  # Make vertical path visible
		line_edit.visible = false  # Hide the horizontal input field
		line_edit_ver.visible = true  # Show the vertical input field
		spritever.visible = true  # Show vertical sprite
		print("Switched to VerticalPath!")
	else:
		print("Not within the correct range yet. Waiting for the correct position.")

# Function to reset the scene
func reset_scene() -> void:
	get_tree().reload_current_scene()
