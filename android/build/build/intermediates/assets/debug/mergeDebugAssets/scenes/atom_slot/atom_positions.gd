extends Node2D
class_name AtomPositions



@onready var center_position: Marker2D = get_node("CenterPosition")

@onready var single: Node2D = get_node("Single")
@onready var double: Node2D = get_node("Double")
@onready var triple: Node2D = get_node("Triple")

@onready var original_positions: Dictionary = {
	"center_global_position" : center_position.global_position, 
} 


