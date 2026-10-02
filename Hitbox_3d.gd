@tool
@icon("res://assets/icons/hit_box_3d.svg")
class_name Hitbox3D
extends Area3D

const CAN_HIT_PLAYER := 0b001
const CAN_HIT_MOB := 0b010
const CAN_HIT_ENVIRONMENT := 0b100
# these lines define what the hitbox can interact with. 

@export var damage := 1
@export_flags("Player", "Mob", "Environment") var can_hit := CAN_HIT_PLAYER:
	set = set_can_hit


#--------------------------------------------------- 
#|    READ THIS BOX FIRST!!! 
#|    This is the HITbox script. this one checks
#|    if an object DOES a hit. (projectiles and weapons)
#----------------------------------------------------

signal hit_hurt_box(hurt_box: Hurtbox3D)
# this chunk signals when colliding with a hurtbox
func _init() -> void:
	monitoring = true
	monitorable = true
	area_entered.connect(
		func _on_area_entered(area: Area3D) -> void:
			if area is Hurtbox3D:
				hit_hurt_box.emit(area)
)

# sets the ability to hit things 
func set_can_hit(new_value: int) -> void:
	can_hit = new_value
	collision_layer = can_hit <<1
	collision_mask = can_hit <<1
