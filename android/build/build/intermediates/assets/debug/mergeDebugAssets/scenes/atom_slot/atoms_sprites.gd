@tool
extends Node2D
class_name AtomsSprites

@export var explode_travel_time: float = 0.1 
@export var shaking_speed: float = 0.1

var _shaking: bool = false

var up_atom: Sprite2D
var left_atom: Sprite2D
var down_atom: Sprite2D
var right_atom: Sprite2D
var atom_sprites_group: Node2D

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var rotation_direction: int
var atom_sprites_orig_values: Array[Dictionary] = []

var shaders: Dictionary = {
	"flash" : "res://shaders/flash/flash.tres"
}

@onready var atoms_detector: AtomsDetector = get_node("../AtomsDetector")
@onready var atom_positions: AtomPositions = get_node("../AtomPositions")
@onready var atom_stack: AtomStack = get_node("../AtomStack")
@onready var atoms_particles: AtomsParticles = get_node("../AtomsParticles")

func _ready() -> void: 
	rng.randomize()
	rotation_direction = [-1, 1][rng.randi_range(0, 1)]
	
	
# This is initialzied after the first physics process frame of the atom slot
# Adds it outside of the AtomSlot so that the modulate of it is seperate. 
func init() -> void: 
	var group: Node2D = Node2D.new()
	atom_sprites_group = group
	get_tree().current_scene.get_node("%AtomSprites").add_child(atom_sprites_group) 
	atom_sprites_group.global_position = atom_positions.original_positions["center_global_position"]
	
	_add_atom_sprite("up_atom")
	_add_atom_sprite("left_atom")
	_add_atom_sprite("down_atom")
	_add_atom_sprite("right_atom")
	
	for atom_sprite in atom_sprites_group.get_children(): 
		atom_sprite.scale *= get_tree().current_scene.get_node("%MapScaler").vector2_scale
		var orig_values: Dictionary = {
			"scale" : atom_sprite.scale, 
			"global_position" : atom_sprite.global_position 
		}
		atom_sprites_orig_values.append(orig_values)
	set_atoms_visible(false)
	
	
func _add_atom_sprite(variable_to_initialize: String) -> void: 
	var sprite: Sprite2D = Sprite2D.new()
	set(variable_to_initialize, sprite)
	atom_sprites_group.add_child(sprite)
	sprite.texture = load("res://scenes/atom_slot/atom.png")
	var scale_size: float = 0.17
	sprite.scale = Vector2(scale_size, scale_size)
	
#func hide_and_show_atoms_logic(new_atom_count: int, previous_atom_count: int) -> void: 
#	var children: Array[Node] = get_children()
#	if new_atom_count <= 0: 
##		set_atoms_visible(false)
#		return
#	var atom_index: int = new_atom_count - 1
#	if Engine.is_editor_hint(): 
#		if new_atom_count < previous_atom_count: 
#			children[atom_index + 1].hide()
#	children[atom_index].show()


func arrange_atoms() -> void: 
	match atom_stack.atom_count: 
		1: 
			up_atom.global_position = atom_positions.single.get_child(0).global_position
			up_atom.show()
			left_atom.global_position = atom_positions.original_positions["center_global_position"]
			left_atom.hide()
			down_atom.global_position = atom_positions.original_positions["center_global_position"]
			down_atom.hide()
			right_atom.global_position = atom_positions.original_positions["center_global_position"]
			right_atom.hide()
		2: 
			up_atom.global_position = atom_positions.double.get_child(0).global_position
			up_atom.show()
			left_atom.global_position = atom_positions.double.get_child(1).global_position
			left_atom.show()
			down_atom.global_position = atom_positions.original_positions["center_global_position"]
			down_atom.hide()
			right_atom.global_position = atom_positions.original_positions["center_global_position"]
			right_atom.hide()
		3: 
			up_atom.global_position = atom_positions.triple.get_child(0).global_position
			up_atom.show()
			left_atom.global_position = atom_positions.triple.get_child(1).global_position
			left_atom.show()
			down_atom.global_position = atom_positions.triple.get_child(2).global_position
			down_atom.show()
			right_atom.global_position = atom_positions.original_positions["center_global_position"]
			right_atom.hide()
		4: 
			up_atom.global_position = atom_positions.triple.get_child(0).global_position
			up_atom.show()
			left_atom.global_position = atom_positions.triple.get_child(1).global_position
			left_atom.show()
			down_atom.global_position = atom_positions.triple.get_child(2).global_position
			down_atom.show()
			right_atom.global_position = atom_positions.original_positions["center_global_position"]
			right_atom.hide()
	
	
func set_atoms_visible(value: bool) -> void: 
	for atom_sprite in atom_sprites_group.get_children(): 
		atom_sprite.set_visible(value)
	
	
func shake_atoms() -> void: 
	var tween: Tween = create_tween()
	_shaking = true
	while _shaking:
		var min_range: int = 1 
		var max_range: int = 7
		
		rng.randomize()
		var x_rand_dir: int = [-1, 1][rng.randi_range(0, 1)]
		var x_rand_pos: int = rng.randi_range(min_range, max_range) * x_rand_dir
		
		rng.randomize()
		var y_rand_dir: int = [-1, 1][rng.randi_range(0, 1)]
		var y_rand_pos: int = rng.randi_range(min_range, max_range) * y_rand_dir
		
		var new_position: Vector2 = Vector2(x_rand_pos, y_rand_pos)
		tween.tween_property(atom_sprites_group, "global_position", atom_positions.original_positions["center_global_position"] + new_position, shaking_speed)
		tween.tween_property(atom_sprites_group, "global_position", atom_positions.original_positions["center_global_position"], shaking_speed)
		tween.play()
		await tween.finished
		tween.stop()
	
	
func stop_shaking_atoms() -> void: 
	_shaking = false
	global_position = atom_positions.original_positions["center_global_position"]
	
	
func rotate_atoms(full_rotation_duration: float = 9, override_rotation_direction: int = 0) -> Tween: 
	rng.randomize()
	var tween: Tween = create_tween().set_loops()
	if override_rotation_direction != 0: 
		tween.tween_property(atom_sprites_group, "rotation", TAU * override_rotation_direction, full_rotation_duration).as_relative()
	else: 
		tween.tween_property(atom_sprites_group, "rotation", TAU * rotation_direction, full_rotation_duration).as_relative()
	tween.play()
	return tween


func explode_animation() -> void: 
	set_atoms_visible(false)
	rotation_degrees = 0
	var available_directions: Array[int] = atoms_detector.get_available_directions() 
	var all_directions: Array = atoms_detector.Directions.keys()
	var distance: float = 64 * GameManager.map_scaler.vector2_scale.x
	var tween: Tween = create_tween().set_parallel(true)
	
#	tween.tween_method(atoms_particles.play_particle, "", "Retro Explosion", 0.01)
	tween.chain() 
	tween.tween_property(atom_sprites_group, "visible", false, 0.01)
	tween.chain()
	tween.tween_property(atom_sprites_group, "visible", true, 0.01)
	tween.chain()
	for atom_sprite in atom_sprites_group.get_children(): 
		tween.tween_property(atom_sprite, "global_position", atom_positions.original_positions["center_global_position"], 0.1)
	tween.chain()
	for dir_index in available_directions: 
		var direction: String = all_directions[dir_index]
		match direction: 
			"UP": 
				up_atom.show()
				atom_explode_to(tween, up_atom, Vector2(0, -distance))
			"LEFT": 
				left_atom.show()
				atom_explode_to(tween, left_atom, Vector2(-distance, 0))
			"DOWN": 
				down_atom.show()
				atom_explode_to(tween, down_atom, Vector2(0, distance))
			"RIGHT": 
				right_atom.show()
				atom_explode_to(tween, right_atom, Vector2(distance, 0))
				
	tween.play()
	await tween.finished
	set_atoms_visible(false)
#	for index in atom_sprites_group_children.size(): 
#		atom_sprites_group_children[index].scale = atom_sprites_orig_values[index]["scale"]
#		atom_sprites_group_children[index].modulate = owner.atom_player.team_color
#	atom_sprites_group.material = null
	
#	tween.play()
#	await tween.finished
#
	for atom_sprite in atom_sprites_group.get_children(): 
		atom_sprite.global_position = atom_positions.original_positions["center_global_position"]
	arrange_atoms()
	
	
func _set_flash_shader_param(value: float) -> void: 
	atom_sprites_group.material.set_shader_parameter("flash_modifier", value)
	
	
func grow_to_size(tween: Tween, node: Node2D, to_size: float, grow_duration: float) -> void: 
	var grow_to_scale: Vector2 = node.scale + Vector2(to_size, to_size) 
	tween.tween_property(node, "scale", grow_to_scale, grow_duration)
	
	
func atom_explode_to(tween: Tween, atom: Sprite2D, distance: Vector2) -> void: 
	atom_transfer_tween(tween, atom, atom.global_position + distance)
	
	
func atom_transfer_tween(tween: Tween, atom: Sprite2D, to: Vector2) -> void: 
	tween.tween_property(atom, "global_position", to, explode_travel_time)


func change_team_color_to(new_team: AtomPlayer) -> void: 
	var team_color: Color 
	if new_team == null: 
		team_color = Color.DIM_GRAY
	else: 
		team_color = new_team.team_color
	up_atom.modulate = team_color
	left_atom.modulate = team_color
	down_atom.modulate = team_color
	right_atom.modulate = team_color


func flash_tween(flash_duration: float, loop: bool = false, loops: int = 0, from_color: Color = AtomPlayerTurnsManager.current_atom_player_in_turn.team_color) -> Tween: 
	if !get_parent().atom_player: 
		return null
	var _flash_tween: Tween = create_tween()
	if loop: 
		_flash_tween.set_loops(loops)
	_flash_tween.set_parallel(true).set_ease(Tween.EASE_IN).bind_node(self)
#	var orig_modulate: Color = get_parent().atom_player.team_color
	for atom_sprite in atom_sprites_group.get_children(): 
		_flash_tween.tween_property(atom_sprite, "modulate", Color(1, 1, 1), flash_duration)
	_flash_tween.chain()
	for atom_sprite in atom_sprites_group.get_children():
		_flash_tween.tween_property(atom_sprite, "modulate", from_color, flash_duration)
	_flash_tween.tween_interval(1.2) 
	_flash_tween.play()
	return _flash_tween

