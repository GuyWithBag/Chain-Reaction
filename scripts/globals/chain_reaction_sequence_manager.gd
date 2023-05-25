extends Node

signal chain_reaction_sequence_started(atom_team_started: AtomTeam)
signal chain_reaction_sequence_finished

signal chain_reaction_sequence_was_reset

var chain_reaction_sequences: Array[ChainReactionSequence] = []
var chain_reaction_just_finished: bool = false


func reset() -> void: 
	reset_sequence()
	
	
func add_sequence(sequence: ChainReactionSequence) -> void: 
	chain_reaction_sequences.append(sequence)
	if chain_reaction_sequences.size() - 1 == 1 && AtomTeamTurnsManager.is_awaiting_turn(): 
		start_chain_reaction(sequence)
	
	
func erase_sequence(sequence: ChainReactionSequence) -> void: 
	chain_reaction_sequences.erase(sequence)
	if chain_reaction_sequences.is_empty() && chain_reaction_just_finished == false: 
		finish_chain_reaction()
	
	
func remove_at_sequence(index: int) -> void: 
	chain_reaction_sequences.remove_at(index)
	if chain_reaction_sequences.is_empty() && chain_reaction_just_finished == false: 
		finish_chain_reaction()
	
	
func pop_back_sequences() -> void: 
#	for sequence in chain_reaction_sequences: 
#		printerr("seq name: ", sequence.atom_slot)
	chain_reaction_sequences.pop_back()
#	printerr(chain_reaction_sequences)
#	printerr(chain_reaction_sequences.is_empty())
	if chain_reaction_sequences.is_empty() && chain_reaction_just_finished == false: 
		finish_chain_reaction()
	
	
func reset_sequence() -> void: 
	chain_reaction_sequences.clear()
	chain_reaction_sequence_was_reset.emit()
	finish_chain_reaction()
	
	
func start_chain_reaction(sequence: ChainReactionSequence) -> void: 
	chain_reaction_sequence_started.emit(sequence.atom_slot.atom_team)
	printerr("STARTED_CHAIN_REACTION")
	AtomTeamTurnsManager.current_state = AtomTeamTurnsManager.State.CHAIN_REACTION
	chain_reaction_just_finished = false
	
	
func finish_chain_reaction() -> void: 
	chain_reaction_sequence_finished.emit()
	printerr("CHAIN_REACTION_FINISHED")
	AtomTeamTurnsManager.current_state = AtomTeamTurnsManager.State.AWAITING_TURN
	AtomTeamTurnsManager.turn_is_next.emit()
	chain_reaction_just_finished = true

