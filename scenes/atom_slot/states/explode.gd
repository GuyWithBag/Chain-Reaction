extends AtomSlotBaseState

signal started_exploding
signal finished_exploding

func enter() -> void: 
	super.enter()
	var neighbor_atom_slots: Array[AtomSlot] = atoms_detector.get_slot_in_all_directions()
#	if AtomSlotsManager.is_tilemap_full_of_cells(): 
#		printerr("full")
#		return
	_explode(neighbor_atom_slots)
	state_machine.change_state(empty_state)


func _explode(neighbor_atom_slots: Array[AtomSlot]) -> void: 
	for neighbor_atom_slot in neighbor_atom_slots: 
		ChainReactionSequenceManager.add_sequence(neighbor_atom_slot.sequence) 
	started_exploding.emit()
	if get_tree().current_scene.has_node("%Root"): 
		var root: Control = get_tree().current_scene.get_node("%Root")
		var cam_shake: ShakeAnimation = ShakeAnimation.new(self, true, 1, 1)
		root.add_child(cam_shake)
		cam_shake.shake_object_randomly(root, cam_shake.PositionType.GLOBAL, root.global_position, 0.08, 1, 7)
#	if CameraManager.shaking: 
#		CameraManager.finished_shaking.connect(
#			func(): 
#				CameraManager.shake_camera(shake_cam_duration, shake_cam_loops)
#		, CONNECT_ONE_SHOT
#		)
#	else: 
#		CameraManager.shake_camera(shake_cam_duration, shake_cam_loops)
	await atoms_sprites.explode_animation() 
	for neighbor_atom_slot in neighbor_atom_slots: 
		var neighbor_atom_stack: AtomStack = neighbor_atom_slot.atom_stack 
		var _previous_atom_player: AtomPlayer = AtomPlayerTurnsManager.get_previous_atom_player_turn()
		_affect_rotation_direction(neighbor_atom_slot)
#		atom_stack.reset_atom_count()
		neighbor_atom_stack.add_atom(1, AtomPlayerTurnsManager.current_atom_player_in_turn)
		
		var shake_animation: ShakeAnimation = ShakeAnimation.new(neighbor_atom_slot, true, 1, 1) 
		var atom_sprites_group: Node2D = neighbor_atom_slot.atoms_sprites.atom_sprites_group
		neighbor_atom_slot.atoms_sprites.add_child(shake_animation)
		shake_animation.shake_object_randomly(atom_sprites_group, ShakeAnimation.PositionType.GLOBAL, atom_sprites_group.global_position, 0.05, 3, 15)
#		AtomSlotsManager.data[state_machine_owner.name] = atom_stack.atom_count
#		AtomSlotsManager.data[neighbor_atom_slot.name] = _atom_stack.atom_count
		ChainReactionSequenceManager.pop_back_sequences()
#	print(AtomSlotsManager.data)
	
	Input.vibrate_handheld(500)
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
	
	

