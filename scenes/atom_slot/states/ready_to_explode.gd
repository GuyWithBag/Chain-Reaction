extends AtomSlotBaseState

var playing: bool = true
var rotate_tween: Tween

func enter() -> void: 
	rotate_tween = animation()
	atom_stack.atoms_over_added.connect(_on_atoms_over_added)
	
	
func exit() -> void: 
	atom_stack.atoms_over_added.disconnect(_on_atoms_over_added)
	atoms_sprites.stop_shaking_atoms()
	rotate_tween.stop()
	
	
func _on_atoms_over_added() -> void: 
	state_machine.change_state(explode_state)


func animation() -> Tween: 
	atoms_sprites.shake_atoms()
	return atoms_sprites.rotate_atoms()

