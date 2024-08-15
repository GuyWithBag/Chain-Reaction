extends AtomSlotBaseState

signal started_exploding
signal finished_exploding

var world: GameWorld
var managers: LocalManagers

func enter() -> void: 
	super.enter()
	world = GameManager.world
	managers = world.managers
#	if AtomSlotsManager.is_tilemap_full_of_cells(): 
#		printerr("full")
#		return
	_explode(owner.neighbor_atom_slots)
	state_machine.change_state(empty_state)


func shake_grid() -> void: 
	var root: Control = get_tree().current_scene.get_node("%Root")
	var cam_shake: ShakeAnimation = ShakeAnimation.shake_object_randomly(get_tree().current_scene, 1, root, ShakeAnimation.PositionType.GLOBAL, root.global_position, 0.08, 1, 7)
	cam_shake.animation_finished.connect(
		func(): 
			root.global_position = Vector2.ZERO
	, CONNECT_ONE_SHOT
	)


func _explode(neighbor_atom_slots: Array[AtomSlot]) -> void: 
	for neighbor_atom_slot in neighbor_atom_slots: 
		managers.chain_reaction_sequences.add_sequence(neighbor_atom_slot.sequence) 
	started_exploding.emit()
	
	if get_tree().current_scene.has_node("%Root"): 
		shake_grid()
		
	await atoms_sprites.explode_animation() 
	for neighbor_atom_slot in neighbor_atom_slots: 
		var neighbor_atom_stack: AtomStack = neighbor_atom_slot.atom_stack 
		var _previous_player: Player = managers.player_turns.get_previous_player_turn()
		_affect_rotation_direction(neighbor_atom_slot)
#		atom_stack.reset_atom_count()
		neighbor_atom_stack.add_atom(1, managers.player_turns.current_player_in_turn)
		var atom_sprites_group: Node2D = neighbor_atom_slot.atoms_sprites.atom_sprites_group
		var _shake_animation: ShakeAnimation = ShakeAnimation.shake_object_randomly(neighbor_atom_slot, 1, atom_sprites_group, ShakeAnimation.PositionType.GLOBAL, atom_sprites_group.global_position, 0.05, 3, 15)
#		AtomSlotsManager.data[neighbor_atom_slot.name] = _atom_stack.atom_count
		managers.chain_reaction_sequences.pop_back_sequences()
#	print(AtomSlotsManager.data) 
	
	Input.vibrate_handheld(100)
	finished_exploding.emit() 
	
	
func _affect_rotation_direction(affected_atom_slot: AtomSlot) -> void: 
		var owner_global_pos: Vector2 = state_machine_owner.global_position 
		var neighbor_global_pos: Vector2 = affected_atom_slot.global_position 
		var x_distance: float = neighbor_global_pos.x - owner_global_pos.x
		var y_distance: float = owner_global_pos.y - neighbor_global_pos.y
		var normalized_distance: Vector2 = Vector2(x_distance, y_distance).normalized()
		var affected_rotation_direction: int = 0
		if normalized_distance == Vector2(0, 1) || normalized_distance == Vector2(1, 0): 
			affected_rotation_direction = 1
		elif normalized_distance == Vector2(0, -1) || normalized_distance == Vector2(-1, 0): 
			affected_rotation_direction = -1
		affected_atom_slot.atom_stack.atoms_sprites.rotation_direction = affected_rotation_direction
	
	

