extends AtomSlotBaseState

var playing: bool = true
var rotate_tween: Tween
var flash_tween: Tween

func enter() -> void: 
	rotate_tween = atoms_sprites.rotate_atoms()
	flash_tween = atoms_sprites.flash_tween(0.3, true)
	atoms_sprites.shake_atoms()
	atom_stack.atoms_over_added.connect(_on_atoms_over_added)
	
	
func exit() -> void: 
	atom_stack.atoms_over_added.disconnect(_on_atoms_over_added)
	atoms_sprites.stop_shaking_atoms()
	flash_tween.stop()
	rotate_tween.stop()
	
	
func _on_atoms_over_added() -> void: 
	state_machine.change_state(explode_state)



