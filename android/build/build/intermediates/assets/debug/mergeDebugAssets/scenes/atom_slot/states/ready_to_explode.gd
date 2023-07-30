extends AtomSlotBaseState

var playing: bool = true
var rotate_tween: Tween
var flash_tween: Tween
var shake_animation: ShakeAnimation

func enter() -> void: 
	rotate_tween = atoms_sprites.rotate_atoms()
	flash_tween = atoms_sprites.flash_tween(0.3, true)
	shake_animation = ShakeAnimation.shake_object_randomly(owner, 120, atoms_sprites.atom_sprites_group, ShakeAnimation.PositionType.GLOBAL, atom_positions.center_position.global_position, 0.1, 1, 7) 
	printerr(owner)
	printerr(shake_animation.playing)
	atom_stack.atoms_overloaded.connect(_on_atoms_overloaded)
	
	
func exit() -> void: 
	atom_stack.atoms_overloaded.disconnect(_on_atoms_overloaded)
	atoms_sprites.stop_shaking_atoms()
	if flash_tween: 
		flash_tween.stop()
	rotate_tween.stop()
	shake_animation.stop() 
	
	
func _on_atoms_overloaded() -> void: 
	state_machine.change_state(explode_state)



