extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animation = $AnimationPlayer



func _process(_delta: float) -> void:
	animation.play("bounce")
