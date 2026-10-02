@tool
class_name Projectile3D extends Hitbox3D

@export var projectile_vfx: PackedScene = null
@export var impact_vfx: PackedScene = null
@onready var _timer= %Timer
var _visual: ProjectileSkin3D = null
var speed :=10.0
var maxrange:=10.0
var _distancetraveled:=0.0
var stationary:=false

func _ready() -> void:
	_visual = projectile_vfx.instantiate()
	add_child(_visual)
	_visual.appear()
	hit_hurt_box.connect(_on_hit)
	_timer.wait_time=maxrange
	_timer.start()

func _physics_process(delta: float) -> void:
	var distance := speed * delta
	var motion := -transform.basis.z * distance
	if stationary:
		_destroy()
	position += motion
	_distancetraveled+=distance
	if _distancetraveled>maxrange:
		_destroy()
	
func _destroy () -> void:
		set_physics_process(false)
		_visual.destroy()
		_visual.tree_exited.connect(queue_free)
		hit_hurt_box.disconnect(_on_hit)

func _on_hit(_node: Hurtbox3D) -> void:
	var impact: Node3D = impact_vfx.instantiate()
	impact.transform = transform
	add_sibling(impact)
	
	_destroy()
