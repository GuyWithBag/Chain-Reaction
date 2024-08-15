extends LocalManager
class_name ChainReactionSequenceManager

signal chain_reaction_sequence_started(player_started: Player)
signal chain_reaction_sequence_finished

signal chain_reaction_sequence_was_reset

var chain_reaction_sequences: Array[ChainReactionSequence] = []
var chain_reaction_just_finished: bool = false

func reset() -> void: 
	reset_sequence()
	
	
func add_sequence(sequence: ChainReactionSequence) -> void: 
	chain_reaction_sequences.append(sequence)
	if chain_reaction_sequences.size() - 1 == 1 && managers.player_turns.is_awaiting_turn(): 
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
#	printerr(chain_reaRction_sequences)
#	printerr(chain_reaction_sequences.is_empty())
	if chain_reaction_sequences.is_empty() && chain_reaction_just_finished == false: 
		finish_chain_reaction()
	
	
func reset_sequence() -> void: 
	chain_reaction_sequences.clear()
	chain_reaction_sequence_was_reset.emit()
	if managers.player_turns.is_chain_reacting(): 
		finish_chain_reaction()
	
	
func start_chain_reaction(sequence: ChainReactionSequence) -> void: 
	chain_reaction_sequence_started.emit(sequence.atom_slot.player)
	if GameManager.debug: 
		print("\nChainReactionSequenceManager: STARTED_CHAIN_REACTION\n")
	managers.player_turns.state_chart.send_event("chain_reaction")
	chain_reaction_just_finished = false
	
	
func finish_chain_reaction() -> void: 
	chain_reaction_sequence_finished.emit()
	if GameManager.debug: 
		print("\nChainReactionSequenceManager: CHAIN_REACTION_FINISHED\n")
	managers.player_turns.state_chart.send_event("awaiting_turn")
	managers.player_turns.next_turn()
	chain_reaction_just_finished = true
