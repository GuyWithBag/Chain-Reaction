extends AtomSlotBaseState


func enter() -> void: 
	atom_stack.atoms_added.connect(_on_atoms_added)
	atom_stack.atoms_maxxed.connect(_on_atoms_maxxed)
	

func exit() -> void: 
	atom_stack.atoms_added.disconnect(_on_atoms_added)
	atom_stack.atoms_maxxed.disconnect(_on_atoms_maxxed)


func _on_atoms_added(_atom_amount_added: int, _new_team: AtomPlayer) -> void: 
	state_machine.change_state(stacked_state)


func _on_atoms_maxxed() -> void: 
	state_machine.change_state(ready_to_explode_state)
