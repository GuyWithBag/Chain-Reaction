extends AtomSlotBaseState

var rotate_tween_1: Tween
var rotate_tween_2: Tween

func enter() -> void: 
	atom_stack.atoms_maxxed.connect(_on_atoms_maxxed)
	atom_stack.atoms_added.connect(_on_atoms_added)
	rotate_tween_1 = atoms_sprites.rotate_atoms(4)


func exit() -> void: 
	atom_stack.atoms_maxxed.disconnect(_on_atoms_maxxed)
	atom_stack.atoms_added.disconnect(_on_atoms_added)
	if rotate_tween_1: 
		rotate_tween_1.stop()


func _on_atoms_added(_atom_amount_added: int, _new_team: AtomPlayer) -> void: 
	if atom_stack.atom_count == 2: 
		rotate_tween_1.stop()
		rotate_tween_2 = atoms_sprites.rotate_atoms(1.7)


func _on_atoms_maxxed() -> void: 
	if rotate_tween_1:
		rotate_tween_1.stop()
	if rotate_tween_2:
		rotate_tween_2.stop()
	state_machine.change_state(ready_to_explode_state)

