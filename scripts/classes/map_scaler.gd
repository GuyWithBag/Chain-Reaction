@tool
extends Node
class_name MapScaler

enum Size {
	_64,
	_96,
	_128, 
	_160
}

@export var tilemap: Node2D
@export var atom_particles: Node2D
@export var tilemap_backdrop: TileMap

@export var scale_by_size: Size: 
	set(value): 
		if !Engine.is_editor_hint(): 
			return
		scale_by_size = value 
		match scale_by_size: 
			Size._64: 
				scale = 1
			Size._96: 
				scale = 1.5
			Size._128: 
				scale = 2
			Size._160: 
				scale = 2.5

@export_range(1, 5, 0.1, "or_greater", "or_lesser") var scale: float = 0: 
	set(value): 
		if !Engine.is_editor_hint(): 
			return
		scale = value
		vector2_scale = Vector2(scale, scale)
		tilemap.scale = vector2_scale
		atom_particles.scale = vector2_scale
		tilemap_backdrop.scale = vector2_scale
#		if has_node("../%AtomSprites"): 
#			get_node("../%AtomSprites").scale = vector2_scale

var vector2_scale: Vector2
var vector2_scale_relative_to_tilemap_size: Vector2: 
	get: 
		return 64 * vector2_scale

var maps: Node2D

func _ready() -> void: 
	if Engine.is_editor_hint(): 
		return
	GameManager.map_scaler = self


func _enter_tree() -> void: 
	scale = scale 
