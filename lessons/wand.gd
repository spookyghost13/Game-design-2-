extends Marker3D
@export var projectile_scene: PackedScene = null
@export var projectile_scene_2: PackedScene = null
@onready var _timer2: Timer = %Timer2
@onready var _timer: Timer = %Timer
@export_range(0,30,1) var fire_rate:=1.0:
	set(new_fire_rate):
		fire_rate=new_fire_rate
		if _timer == null:
			return
		_timer.wait_time=(1.0/fire_rate)
	get:
		return fire_rate
		
@export_range(5.0, 100.0, 0.5) var projectile_speed := 12.0
@export_range(2.0, 40.0, 0.5) var max_range := 12.0
@export_range(0.0, 90.0, 0.5, "radians_as_degrees") var bullet_spread := PI / 10.0

func _ready() -> void:
	fire_rate=fire_rate
	

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("shoot") and _timer.is_stopped():
		shoot()
	elif Input.is_action_pressed("bigshoot") and _timer2.is_stopped():
		bigshoot()

func shoot() -> void:
	var projectile: Projectile3D = projectile_scene.instantiate()
	# Add the projectile as a sibling of the player so it is not affected by the wand or the player's transform.
	owner.add_sibling(projectile)
	projectile.global_transform=global_transform
	var spreadangle:=randf_range(-bullet_spread/2.0, bullet_spread/2.0)
	projectile.rotate_y(spreadangle)
	projectile.maxrange=max_range
	projectile.speed=projectile_speed
	projectile.can_hit=0b010
	_timer.start()

func bigshoot() -> void:
	var projectile: Projectile3D = projectile_scene_2.instantiate()
	# Add the projectile as a sibling of the player so it is not affected by the wand or the player's transform.
	owner.add_sibling(projectile)
	projectile.stationary=true
	projectile.global_transform=global_transform
	projectile.speed=0.0
	projectile.maxrange=3.0
	projectile.can_hit=0b110
	_timer2.start()
