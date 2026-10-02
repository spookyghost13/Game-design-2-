extends CharacterBody3D

@export_range(3.0, 12.0, 0.1) var max_speed := 6.0
@export_range(1.0, 50.0, 0.1) var steering_factor := 20.0
@onready var _gobot_skin_3d: GobotSkin3D = %GobotSkin3D
@onready var _camera_3d: Camera3D = %Camera3D

const GRAVITY := 40.0* Vector3.DOWN
var _ground_plane := Plane(Vector3.UP)


func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("moveL", "moveR", "moveF", "moveB")
	var direction :=Vector3(input_vector.x, 0.0, input_vector.y)
	
	if is_on_floor() and not direction.is_zero_approx():
		_gobot_skin_3d.run()
	else:
		_gobot_skin_3d.idle()
	
	_ground_plane.d=global_position.y
	var mousepos2d:=get_viewport().get_mouse_position()
	var mouse_ray:= _camera_3d.project_ray_normal(mousepos2d)
	var worldmousepos: Variant = _ground_plane.intersects_ray(_camera_3d.global_position, mouse_ray)
	if worldmousepos != null:
		_gobot_skin_3d.look_at(worldmousepos)
		
	if input_vector.length() > 0.0:
		var skin_forward_vector := -1.0 * _gobot_skin_3d.global_basis.z
		_gobot_skin_3d.hips_rotation = skin_forward_vector.signed_angle_to(direction, Vector3.UP)
	
	var desGroundVel := max_speed*direction
	var steeringVec := desGroundVel-velocity
	steeringVec.y=0.0
	var steerAmount :float =min(steering_factor*delta, 1.0)
	velocity += steeringVec * steerAmount
	velocity += GRAVITY*delta
	
	move_and_slide()
