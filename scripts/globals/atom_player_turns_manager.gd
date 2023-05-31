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

var take_turns_looping: bool = false

var turn_index: int = 0

var current_atom_player_in_turn: AtomPlayer: 
	set(value): 
		var previous_atom_player: AtomPlayer = current_atom_player_in_turn
		current_atom_player_in_turn = value
		changed_current_atom_player_in_turn.emit(previous_atom_player, current_atom_player_in_turn)
	
	
func reset() -> void: 
	turn_index = 0
	take_turns_looping = false
	next_turn()
	current_atom_player_in_turn = null
	
	
func start_game() -> void: 
	take_turns_looping = true
	take_turns_loop()
	
	
func take_turns_loop() -> void: 
	while take_turns_looping:  
		var atom_players_in_play: Array[AtomPlayer] = AtomPlayersManager.atom_players_in_play
		if turn_index >= atom_players_in_play.size(): 
			return
		current_atom_player_in_turn = atom_players_in_play[turn_index]
		print("AtomPlayerTurnsManager: Current team: ", atom_players_in_play[turn_index].team_number)
		turn_started.emit()
		turn_index += 1 
		if turn_index >= atom_players_in_play.size(): 
			turn_index = 0
		await turn_is_next
	
	
func is_chain_reacting() -> bool: 
	if current_state == State.CHAIN_REACTION: 
		return true
	return false
	
	
func is_awaiting_turn() -> bool: 
	if current_state == State.AWAITING_TURN: 
		return true
	return false
	
	
func get_previous_atom_player_turn() -> AtomPlayer: 
	var atom_players_in_play: Array[AtomPlayer] = AtomPlayersManager.atom_players_in_play
	var previous_atom_player_index: int = atom_players_in_play.find(current_atom_player_in_turn) - 1
	var previous_atom_player: AtomPlayer = atom_players_in_play[previous_atom_player_index]
	return previous_atom_player
	
	
func next_turn() -> void: 
	turn_is_next.emit()


# Called from UndoHistorymanager
func apply_undo_changes(turn_data: TurnData) -> void:  
#	next_turn() 
	turn_index = turn_data.turn_index 
	next_turn()
	
