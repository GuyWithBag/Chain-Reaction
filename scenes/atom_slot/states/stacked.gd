extends AtomSlotBaseState


func enter() -> void: 
	atom_stack.atoms_maxxed.connect(_on_atoms_maxxed)


func exit() -> void: 
	atom_stack.atoms_maxxed.disconnect(_on_atoms_maxxed)


func _on_atoms_maxxed() -> void: 
	state_machine.change_state(ready_to_explode_state)

