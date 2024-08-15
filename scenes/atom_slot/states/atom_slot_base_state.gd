extends BaseState
class_name AtomSlotBaseState

@export var play_particle: String

var atom_stack: AtomStack
var atoms_detector: AtomsDetector
var atoms_sprites: AtomsSprites
var atoms_particles: AtomsParticles
var atom_positions: AtomPositions

var stacked_state: AtomSlotBaseState
var ready_to_explode_state: AtomSlotBaseState
var empty_state: AtomSlotBaseState
var explode_state: AtomSlotBaseState

var sequence: ChainReactionSequence

func init(_state_machine_owner: Node2D) -> void: 
	super.init(_state_machine_owner)
	atom_stack = _state_machine_owner.get_node("AtomStack")
	atoms_detector = _state_machine_owner.get_node("AtomsDetector")
	atoms_sprites = _state_machine_owner.get_node("AtomsSprites")
	atoms_particles = _state_machine_owner.get_node("AtomsParticles")
	atom_positions = _state_machine_owner.get_node("AtomPositions")

	stacked_state = state_machine.get_node("Stacked")
	ready_to_explode_state = state_machine.get_node("ReadyToExplode")
	empty_state = state_machine.get_node("Empty")
	explode_state = state_machine.get_node("Explode")

	sequence = state_machine_owner.sequence


func enter() -> void: 
	super.enter()
	if !play_particle.is_empty(): 
		atoms_particles.play_particle(play_particle, atom_positions.center_position.global_position)
	
	
