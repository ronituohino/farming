extends CharacterBody3D

# Tutorial by:
# https://www.gdquest.com/library/character_movement_3d_platformer/

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity = 0.25
@export var tilt_upper_limit := PI / 3.0
@export var tilt_lower_limit := -PI / 6.0

@onready var _camera: Node3D = %Camera3D
@onready var _camera_pivot: Node3D = %CameraPivot

var _camera_input_direction := Vector2.ZERO

@export_group("Movement")
@export var move_speed := 8.0
@export var acceleration := 20.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and 
		Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity

func _physics_process(delta: float) -> void:
	_camera_pivot.rotation.x += _camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, tilt_lower_limit, tilt_upper_limit)
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta
	_camera_input_direction = Vector2.ZERO
	
	var raw_input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	print(_camera.global_basis.z)
