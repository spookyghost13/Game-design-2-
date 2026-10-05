extends CharacterBody3D


const SPEED = 10.5
const JUMP_VELOCITY = 9.8
var canjump=true
var gravity=Vector3(0,-15.8,0)
var moveblock=true

func _physics_process(delta: float) -> void:
	_update_camera(delta)
	moveblock=false
	# Add the gravity.
	if is_on_floor() or is_on_wall():
		canjump=true
		if is_on_wall_only():
			velocity+=gravity*delta
	else:
		velocity += gravity * delta
	if (is_on_floor() or is_on_wall() == false) and canjump and $coyotetimer.is_stopped():
		$coyotetimer.start()
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and canjump:
		if is_on_wall_only():
			velocity+=get_wall_normal()*Vector3(2000, 0, 2000)*delta
			#velocity.x=get_wall_normal().x*-2*delta
			#velocity.z=get_wall_normal().z*-2*delta
			velocity.y = JUMP_VELOCITY/1.11
			if Input.is_action_pressed("moveF") or Input.is_action_pressed("moveB") or Input.is_action_pressed("moveL") or Input.is_action_pressed("moveR"):
				moveblock=true
		else:
			velocity.y = JUMP_VELOCITY
		canjump=false
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("moveL", "moveR", "moveF", "moveB")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if not moveblock:
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

var _mouse_input : bool = false
var _mouse_rotation : Vector3
var _rotation_input : float
var _tilt_input : float
var _player_rotation : Vector3
var _camera_rotation : Vector3


func _unhandled_input(event):
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input :
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY

@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(30.0)
@export var CAMERA_CONTROLLER : Camera3D
@export var MOUSE_SENSITIVITY : float = 0.5 




func _update_camera(delta):
	
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta
	
	_player_rotation = Vector3(0.0,_mouse_rotation.y,0.0)
	_camera_rotation = Vector3(_mouse_rotation.x,0.0,0.0)
	
	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	CAMERA_CONTROLLER.rotation.z = 0.0
	
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	_rotation_input = 0.0
	_tilt_input = 0.0


func _on_coyotetimer_timeout() -> void:
	canjump=false
