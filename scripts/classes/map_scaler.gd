@tool
extends Node
class_name MapScaler

enum Size {
	_64,
	_96,
	_128
}

@export var scale_by_size: Size: 
	set(value): 
		scale_by_size = value 
		match scale_by_size: 
			Size._64: 
				scale = 1
			Size._96: 
				scale = 1.5
			Size._128: 
				scale = 2
					
@export_range(1, 5, 0.1, "or_greater", "or_lesser") var scale: float = 0: 
	set(value): 
		scale = value
		vector2_scale = Vector2(scale, scale)
		if Engine.is_editor_hint(): 
			maps = get_node("%TileMaps")
			maps.scale = vector2_scale

var vector2_scale: Vector2

@onready var maps: Node2D = get_node("%TileMaps")
@onready var atom_sprites: Node2D = get_node("%AtomSprites")
@onready var atom_particles: Node2D = get_node("%AtomParticles")


func _ready() -> void: 
	GameManager.map_scaler = self

	
	
	

