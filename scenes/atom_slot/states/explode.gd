extends AtomSlotBaseState


func enter() -> void: 
	var atom_slots: Array[AtomSlot] = atoms_detector.get_slot_in_all_directions()
	_explode(atom_slots)
	state_machine.change_state(empty_state)


func _explode(atom_slots: Array[AtomSlot]) -> void: 
	await atoms_sprites.explode_animation()
	for atom_slot in atom_slots: 
		var _atom_stack: AtomStack = atom_slot.atom_stack
		_atom_stack.add_atom(1, state_machine_owner.atom_team)
	print(atoms_detector.return_all_max_atom_stack())
	
