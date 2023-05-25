@tool
extends Node2D
class_name AtomsSprites

@export var explode_travel_time: float = 0.5
@export var shaking_speed: float = 0.1

var _shaking: bool = false

var up_atom: Sprite2D
var left_atom: Sprite2D
var down_atom: Sprite2D
var right_atom: Sprite2D
var atom_sprites_group: Node2D

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var rotate_dir: int

@onready var atoms_detector: AtomsDetector = get_node("../AtomsDetector")
@onready var atom_positions: AtomPositions = get_node("../AtomPositions")
@onready var atom_stack: AtomStack = get_node("../AtomStack")


func _ready() -> void: 
	_initiate_atom_sprites()
	rng.randomize()
	rotate_dir = [-1, 1][rng.randi_range(0, 1)]
	set_atoms_visible(false)
	
	
# Adds it outsid e of the AtomSlot so that the modulate of it is seperate. 
func _initiate_atom_sprites() -> void: 
	var group: Node2D = Node2D.new()
	atom_sprites_group = group
	GameManager.game_world.atom_sprites.add_child(atom_sprites_group) 
	atom_sprites_group.global_position = atom_positions.center_position.global_position
	_add_atom_sprite("up_atom")
	_add_atom_sprite("left_atom")
	_add_atom_sprite("down_atom")
	_add_atom_sprite("right_atom")
	
	
	
func _add_atom_sprite(variable_to_initialize: String) -> void: 
	var sprite: Sprite2D = Sprite2D.new()
	set(variable_to_initialize, sprite)
	atom_sprites_group.add_child(sprite)
	sprite.texture = load("res://scenes/atom_slot/atom.png")
	sprite.scale = Vector2(0.2, 0.2)
	
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
			left_atom.global_position = atom_positions.center_position.global_position
			left_atom.hide()
			down_atom.global_position = atom_positions.center_position.global_position
			down_atom.hide()
			right_atom.global_position = atom_positions.center_position.global_position
			right_atom.hide()
		2: 
			up_atom.global_position = atom_positions.double.get_child(0).global_position
			up_atom.show()
			left_atom.global_position = atom_positions.double.get_child(1).global_position
			left_atom.show()
			down_atom.global_position = atom_positions.center_position.global_position
			down_atom.hide()
			right_atom.global_position = atom_positions.center_position.global_position
			right_atom.hide()
		3: 
			up_atom.global_position = atom_positions.triple.get_child(0).global_position
			up_atom.show()
			left_atom.global_position = atom_positions.triple.get_child(1).global_position
			left_atom.show()
			down_atom.global_position = atom_positions.triple.get_child(2).global_position
			down_atom.show()
			right_atom.global_position = atom_positions.center_position.global_position
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
		tween.tween_property(atom_sprites_group, "position", atom_positions.center_position.global_position + new_position, shaking_speed)
		tween.tween_property(atom_sprites_group, "position", atom_positions.center_position.global_position, shaking_speed)
		tween.play()
		await tween.finished
		tween.stop()
	
	
func stop_shaking_atoms() -> void: 
	_shaking = false
	global_position = atom_positions.center_position.global_position
	
	
func rotate_atoms(full_rotation_duration: float = 10) -> Tween: 
	rng.randomize()
	var tween: Tween = create_tween().set_loops()
	tween.tween_property(atom_sprites_group, "rotation", TAU * rotate_dir, full_rotation_duration).as_relative()
	tween.play()
	return tween


func explode_animation() -> void: 
	set_atoms_visible(false)
	rotation_degrees = 0
	var tween: Tween = create_tween().set_parallel(true)
	var available_directions: Array[int] = atoms_detector.get_available_directions() 
	var all_directions: Array = atoms_detector.Directions.keys()
	var distance: int = 64 * GameManager.game_world.tilemaps.scale.x
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
	for atom_sprite in atom_sprites_group.get_children(): 
		atom_sprite.global_position = atom_positions.center_position.global_position
	set_atoms_visible(false)
	arrange_atoms()
	
	
func atom_explode_to(tween: Tween, atom: Sprite2D, distance: Vector2) -> void: 
	atom_transfer_tween(tween, atom,  atom.global_position + distance)
	
	
func atom_transfer_tween(tween: Tween, atom: Sprite2D, to: Vector2) -> void: 
	tween.tween_property(atom, "global_position", to, explode_travel_time)


func change_team_color_to(new_team: AtomTeam) -> void: 
	up_atom.modulate = new_team.team_color
	left_atom.modulate = new_team.team_color
	down_atom.modulate = new_team.team_color
	right_atom.modulate = new_team.team_color

