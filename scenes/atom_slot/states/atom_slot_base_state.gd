extends BaseState
class_name AtomSlotBaseState

var atom_stack: AtomStack
var atoms_detector: AtomsDetector
var atoms_sprites: AtomsSprites

var stacked_state: AtomSlotBaseState
var ready_to_explode_state: AtomSlotBaseState
var empty_state: AtomSlotBaseState
var explode_state: AtomSlotBaseState

func init(_state_machine_owner: Node2D) -> void: 
	super.init(_state_machine_owner)
	atom_stack = _state_machine_owner.get_node("AtomStack")
	atoms_detector = _state_machine_owner.get_node("AtomsDetector")
	atoms_sprites = _state_machine_owner.get_node("AtomsSprites")

	stacked_state = state_machine.get_node("Stacked")
	ready_to_explode_state = state_machine.get_node("ReadyToExplode")
	empty_state = state_machine.get_node("Empty")
	explode_state = state_machine.get_node("Explode")
