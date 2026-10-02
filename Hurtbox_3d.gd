@tool
@icon("res://assets/icons/hurt_box_3d.svg")
class_name Hurtbox3D
extends Area3D

#--------------------------------------------------- 
#|    READ THIS BOX FIRST!!! 
#|    This is the HURTbox script. this one checks
#|    if an object TAKES a hit. (targets , enemies, player)
#----------------------------------------------------


signal took_hit(hit_box: Hitbox3D)
# this chunk signals when colliding with a hitbox
func _init() -> void:
	monitoring = true
	monitorable = true
	area_entered.connect(
		func _on_area_entered(area: Area3D) -> void:
			if area is Hitbox3D:
				took_hit.emit(area)
)

const PLAYER_HITS := 0b001
const MOB_HITS := 0b010
const ENVIRONMENT_HITS := 0b100

@export var damage := 1
@export_flags("Player", "Mob", "Environment") var counts_as := PLAYER_HITS:
	set = set_counts_as

func set_counts_as(new_value: int) -> void:
	counts_as = new_value
	collision_mask = counts_as <<1
	collision_layer = counts_as <<1
