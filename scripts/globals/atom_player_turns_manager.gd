extends Node

# Emitted by CHainReactionSequenceManager
signal turn_started
signal turn_is_next
signal changed_current_atom_player_in_turn(previous_atom_player: AtomPlayer, new_atom_player: AtomPlayer)

enum State {
	AWAITING_TURN, 
	CHAIN_REACTION
}

var current_state: State = State.AWAITING_TURN: 
	set(value): 
		current_state = value
		printerr("AtomPlayerTurnsManager: current_state: ", State.keys()[current_state])


var atom_player_turns: Array[AtomPlayer] = []

var current_atom_player_in_turn: AtomPlayer: 
	set(value): 
		var previous_atom_player: AtomPlayer = current_atom_player_in_turn
		current_atom_player_in_turn = value
		changed_current_atom_player_in_turn.emit(previous_atom_player, current_atom_player_in_turn)
	
	
func reset() -> void: 
	atom_player_turns.clear()
	current_atom_player_in_turn = null
	
	
func start_game() -> void: 
	initialize_team_turns()
	take_turns_loop()
	
	
func take_turns_loop() -> void: 
	var index: int = 0 
	while true: 
		current_atom_player_in_turn = atom_player_turns[index]
		print("AtomPlayerTurnsManager: Current team: ", atom_player_turns[index].team_number)
		turn_started.emit()
		index += 1 
		if index >= atom_player_turns.size(): 
			index = 0
		await turn_is_next
		
		
func initialize_team_turns() -> void: 
	atom_player_turns.append_array(AtomPlayersManager.atom_players)
	
	
func is_chain_reacting() -> bool: 
	if current_state == State.CHAIN_REACTION: 
		return true
	return false
	
	
func is_awaiting_turn() -> bool: 
	if current_state == State.AWAITING_TURN: 
		return true
	return false
	
	
func get_previous_atom_player_turn() -> AtomPlayer: 
	var previous_atom_player_index: int = atom_player_turns.find(current_atom_player_in_turn) - 1
	var previous_atom_player: AtomPlayer = atom_player_turns[previous_atom_player_index]
	return previous_atom_player
	
	
func next_turn() -> void: 
	turn_is_next.emit()
	
