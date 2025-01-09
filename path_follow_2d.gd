extends PathFollow2D

@onready var line_edit = $"../CanvasLayer/LineEdit"
@onready var win_label = $"../CanvasLayer/Label"
@onready var popup_panel = $"../CanvasLayer/Popup"
@onready var start_pointer_hor = $"/root/Game/StartPointerHor"
@onready var try_again_button = popup_panel.get_node("Button")
@onready var end_pointer_hor = $"/root/Game/EndPointerHor"
@onready var start_pointer_ver = $"/root/Game/StartPointerVer"
@onready var end_pointer_ver = $"/root/Game/EndPointerVer"
@onready var horizontal_path = $"/root/Game/HorizontalPath"
@onready var vertical_path = $"/root/Game/VerticalPath"
@onready var line_edit_ver = $"/root/Game/VerticalPath/CanvasLayer2/LineEdit"
#@onready var sprite = $AnimatedSprite2D  # Reference to the AnimatedSprite2D node
@onready var spritever = $"/root/Game/VerticalPath/VerPathFollow/Sprite2D"
@onready var rep = $/root/Game/VerticalPath/rep
@onready var mus = $/root/Game/HorizontalPath/HorPathFollow/Sprite2D
@onready var mus_vert = $/root/Game/VerticalPath/VerPathFollow/Sprite2D
@onready var ost = $/root/Game/VerticalPath/ost
@onready var ver_path_follow = $"/root/Game/VerticalPath/VerPathFollow"

var target_ratio: float = 0.0
var smooth_speed: float = 1.0
var rng = RandomNumberGenerator.new()
var targetnumber_hor: float = 0.0
var targetnumber_ver: float = 0.0
var value_entered: bool = false

func round_to(value: float, decimals: int) -> float:
	var factor = pow(10, decimals)
	return round(value * factor) / factor

func _ready():
	targetnumber_hor = round_to(rng.randf_range(0.0, 1.0), 3)
	targetnumber_ver = round_to(rng.randf_range(0.1, 0.9), 3)
	rep.position.x = targetnumber_hor * 1000 - 1200
	#mus.position.y = targetnumber_hor * 1000 - 700
	
	mus_vert.position.y = targetnumber_hor * 1000 - 1020
	ost.position.x = targetnumber_hor * 1000 - 1200
	ost.position.y = targetnumber_ver * -1000 + 1000
	end_pointer_ver.position.x = targetnumber_hor * 1000 + 575
	start_pointer_ver.position.x = targetnumber_hor * 1000 + 575

	print("Target number horizontal is:", targetnumber_hor)

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

func _on_text_submitted(text: String) -> void:
	if text.is_valid_float():
		var input_number = int(text)
		if input_number >= 0 and input_number <= 100:
			target_ratio = round_to(input_number / 100.0, 1)
			line_edit.editable = false
			value_entered = true
			print("New target progress_ratio:", target_ratio)
		else:
			print("Invalid input: Enter a number between 0 and 9.")
			show_popup()
	else:
		print("Invalid input: Please enter a valid number.")
		show_popup()

	line_edit.clear()

func _process(delta: float) -> void:
	# Smoothly update the progress ratio
	progress_ratio = round_to(lerp(progress_ratio, target_ratio, 1.0 - pow(0.01, smooth_speed * delta)), 3)

	if value_entered:
		if abs(progress_ratio - targetnumber_hor) < 0.05 and abs(progress_ratio - target_ratio) < 0.05:
			correct_hor()
		else:
			if not popup_panel.visible:
				show_popup()
	else:
		if popup_panel != null and popup_panel.visible:
			popup_panel.visible = false

	# Horizontal animation logic
	if abs(progress_ratio - target_ratio) > 0.01:  # If moving horizontally
		if not mus.is_playing():
			mus.play("new_animation")
	else:
		mus.stop()

	# Vertical animation logic
	if vertical_path.visible:  # Check if we're on the vertical path
		if abs(progress_ratio - target_ratio) > 0.01:  # If moving vertically
			if not mus_vert.is_playing():
				mus_vert.play("new_animation")
		else:
			mus_vert.stop()

		
	

func show_popup():
	if popup_panel != null:
		popup_panel.visible = true
		popup_panel.get_node("Label").text = "Unfortunately, this was wrong. Please try again!"
		print("Popup displayed: Incorrect value entered.")

func correct_hor():
	if popup_panel.visible:
		popup_panel.visible = false

	if abs(progress_ratio - targetnumber_hor) < 0.07:
		start_pointer_hor.visible = false
		end_pointer_hor.visible = false
		start_pointer_ver.visible = true
		end_pointer_ver.visible = true

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
