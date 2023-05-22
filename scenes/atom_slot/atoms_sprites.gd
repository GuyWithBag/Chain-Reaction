@tool
extends Node2D
class_name AtomsSprites

var _shaking: bool = false

@onready var atoms_detector: AtomsDetector = get_node("../AtomsDetector")
@onready var atom_positions: AtomPositions = get_node("../AtomPositions")
@onready var atom_stack: AtomStack = get_node("../AtomStack")


func hide_and_show_atoms_logic(new_atom_count: int, previous_atom_count: int) -> void: 
	var children: Array[Node] = get_children()
	if new_atom_count <= 0: 
#		set_atoms_visible(false)
		return
	var atom_index: int = new_atom_count - 1
	if Engine.is_editor_hint(): 
		if new_atom_count < previous_atom_count: 
			children[atom_index + 1].hide()
	children[atom_index].show()


func arrange_atoms() -> void: 
	var children: Array[Node] = get_children()
	match atom_stack.atom_count: 
		1: 
			children[0].global_position = atom_positions.single.get_child(0).global_position
			children[0].show()
			children[1].global_position = atom_positions.center_position.global_position
			children[2].global_position = atom_positions.center_position.global_position
			children[3].global_position = atom_positions.center_position.global_position
		2: 
			children[0].global_position = atom_positions.double.get_child(0).global_position
			children[0].show()
			children[1].global_position = atom_positions.double.get_child(1).global_position
			children[1].show()
			children[2].global_position = atom_positions.center_position.global_position
			children[3].global_position = atom_positions.center_position.global_position
		3: 
			children[0].global_position = atom_positions.triple.get_child(0).global_position
			children[0].show()
			children[1].global_position = atom_positions.triple.get_child(1).global_position
			children[1].show()
			children[2].global_position = atom_positions.triple.get_child(2).global_position
			children[2].show()
			children[3].global_position = atom_positions.center_position.global_position
	
	
func set_atoms_visible(value: bool) -> void: 
	for atom_sprite in get_children(): 
		atom_sprite.set_visible(value)
	
	
func shake_atoms() -> void: 
	var tween: Tween = create_tween()
	var rng: RandomNumberGenerator = RandomNumberGenerator.new() 
	_shaking = true
	while _shaking:
		var min_range: int = 1 
		var max_range: int = 7
		
		var x_rand_dir: int = [-1, 1][rng.randi_range(0, 1)]
		var x_rand_pos: int = rng.randi_range(min_range, max_range) * x_rand_dir
		rng.randomize()
		
		var y_rand_dir: int = [-1, 1][rng.randi_range(0, 1)]
		var y_rand_pos: int = rng.randi_range(min_range, max_range) * y_rand_dir
		rng.randomize()
		
		var new_position: Vector2 = Vector2(x_rand_pos, y_rand_pos)
		tween.tween_property(self, "global_position", atom_positions.center_position.global_position + new_position, 0.1)
		tween.tween_property(self, "global_position", atom_positions.center_position.global_position, 0.1)
		tween.play()
		await tween.finished
		tween.stop()
	
	
func stop_shaking_atoms() -> void: 
	_shaking = false
	global_position = atom_positions.center_position.global_position
	
	
func rotate_atoms() -> Tween: 
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	var rand_rotate_dir: int = [-1, 1][rng.randi_range(0, 1)]
	rng.randomize()
	var tween: Tween = create_tween()
	tween.tween_property(self, "rotation", TAU * rand_rotate_dir, 10).as_relative()
	tween.play()
	return tween


func explode_animation() -> void: 
	set_atoms_visible(true)
	rotation_degrees = 0
	var atom_sprites: Array[Node] = get_children()
	var tween: Tween = create_tween().set_parallel(true)
	var available_directions: Array[String] = atoms_detector.get_available_directions()
	for direction in available_directions: 
		match direction: 
			"UP": 
				atom_explode_to(tween, atom_sprites[1], Vector2(0, -64))
			"DOWN": 
				atom_explode_to(tween, atom_sprites[0], Vector2(0, 64))
			"RIGHT": 
				atom_explode_to(tween, atom_sprites[2], Vector2(64, 0))
			"LEFT": 
				atom_explode_to(tween, atom_sprites[3], Vector2(-64, 0))
	tween.play()
	await tween.finished
	for atom_sprite in atom_sprites: 
		atom_sprite.global_position = atom_positions.center_position.global_position
	set_atoms_visible(false)
	arrange_atoms()
	
	
func atom_explode_to(tween: Tween, atom: Sprite2D, distance: Vector2) -> void: 
	atom_transfer_tween(tween, atom,  atom.global_position + distance)
	
	
func atom_transfer_tween(tween: Tween, atom: Sprite2D, to: Vector2) -> void: 
	tween.tween_property(atom, "global_position", to, 0.2)

