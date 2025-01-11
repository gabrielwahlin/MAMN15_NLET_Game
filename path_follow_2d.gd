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
@onready var tallinje = $/root/Game/VerticalPath/Tallinje
@onready var mus = $/root/Game/HorizontalPath/HorPathFollow/Sprite2D
@onready var mus_vert = $/root/Game/VerticalPath/VerPathFollow/Sprite2D
@onready var ost = $/root/Game/VerticalPath/ost
@onready var x_ost = $/root/Game/VerticalPath/Xost
@onready var ver_path_follow = $"/root/Game/VerticalPath/VerPathFollow"
@onready var spiky1 = $/root/Game/spikar/Spiky
@onready var spiky2 = $/root/Game/spikar/Spiky2
@onready var spiky3 = $/root/Game/spikar/Spiky3
@onready var celebration = $"../../celebr"

var target_ratio: float = 0.0
var smooth_speed: float = 1.0
var rng = RandomNumberGenerator.new()
var targetnumber_hor: float = 0.0
var targetnumber_ver: float = 0.0
var play_ani: bool = false
var value_entered: bool = false
var is_moving: bool = false  # Track whether movement should happen
var elapsed_time_hor: float = 0.0
var looptime: float = 0.0
var thr: float = 0.0
var time_hor_flag: bool = false
var while_flag: bool = false
var elapse_walk_time: float = 0.0
# Round function to limit decimals
func round_to(value: float, decimals: int) -> float:
	var factor = pow(10, decimals)
	return round(value * factor) / factor

# Initialization of the paths, sprites, and numbers
func _ready():
	targetnumber_hor = round_to(rng.randf_range(0.0, 1.0), 2)
	targetnumber_ver = round_to(rng.randf_range(0.0, 1.0), 2)
	#targetnumber_ver = 1
	# Set the positions of elements on the horizontal and vertical paths
	#rep.position.x = targetnumber_hor * 835 - 1225
	#mus_vert.position.y = targetnumber_hor * 835 - 1040
	x_ost.position.x = targetnumber_hor * 855 - 1070
	ost.position.y = targetnumber_ver * -855 + 830
	#end_pointer_ver.position.x = targetnumber_hor * 750 + 575
	#start_pointer_ver.position.x = targetnumber_hor * 750 + 575
	
	# Set positions of spiky obstacles
	#spiky1.global_position.x = rep.global_position.x + 60
	#spiky2.global_position.x = rep.global_position.x + 60
	#spiky3.global_position.x = rep.global_position.x + 60

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
			target_ratio = round_to((input_number) / 100.0, 2)

			line_edit.editable = false
			value_entered = true
			is_moving = true  # Start moving after valid input
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
	elapsed_time_hor += delta
	looptime += delta
	# Smoothly update the progress ratio only when the player input is valid
	if progress_ratio < target_ratio:
		progress_ratio = progress_ratio + smooth_speed * delta
	# Horizontal animation logic
	if value_entered and (targetnumber_hor - progress_ratio) > 0.01 and not play_ani:  # If moving horizontally
			play_ani = true
			mus.play("new_animation")
	elif abs(target_ratio - progress_ratio) < 0.05 and value_entered:
		mus.stop()
		if time_hor_flag != true:
			print("Elapsed Time: " + str(elapsed_time_hor) + " seconds")
			thr = elapsed_time_hor
			time_hor_flag = true
			
		
	# Check if the target has been reached and update UI accordingly
	if value_entered and not mus.is_playing():
		if abs(targetnumber_hor - target_ratio) <= 0.051:
			await get_tree().create_timer(1).timeout
			while not while_flag:
				mus.play("new_animation")
				await get_tree().create_timer(0.1).timeout
				progress_ratio += smooth_speed * 0.001
				if abs(1 - progress_ratio) < 0.05:
					while_flag = true
					elapse_walk_time = looptime - thr
			mus.stop()
			correct_hor()
			
			popup_panel.visible = false
			is_moving = false
		else:
			is_moving = false
			if popup_panel != null and not popup_panel.visible:
				show_popup(
					"Ajajaj, du gissade: "
					+ str(target_ratio*100)
					+ " Rätt svar är: "
					+ str(targetnumber_hor * 100)
				)
	else:
		#is_moving = false
		if popup_panel != null and popup_panel.visible:
			popup_panel.visible = false

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
	#if abs(progress_ratio - targetnumber_hor) < 0.07:
	# Hide the horizontal pointers and numbers
	start_pointer_hor.visible = false
	end_pointer_hor.visible = false
	start_number_hor.visible = false
	end_number_hor.visible = false
	x_ost.visible = false
	ost.visible = true
	rep.modulate.a = 1
	tallinje.modulate.a = 0.2
	
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
	#else:
		#print("Not within the correct range yet. Waiting for the correct position.")

# Function to reset the scene
func reset_scene() -> void:
	get_tree().reload_current_scene()
