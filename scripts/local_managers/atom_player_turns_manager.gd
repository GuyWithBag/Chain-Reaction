extends LocalManager
class_name PlayersTurnsManager

# Emitted by CHainReactionSequenceManager
signal turn_started
signal turn_ended
signal turn_is_next
signal changed_current_player_in_turn(previous_player: Player, new_player: Player)

enum State {
	AWAITING_TURN, 
	CHAIN_REACTION 
}

@export var state_chart: StateChart
@export var awaiting_turn: State
@export var chain_reaction: State

#var current_state: State = State.AWAITING_TURN: 
	#set(value): 
		#current_state = value
		#if GameManager.debug: 
			#print("PlayerTurnsManager: current_state: ", State.keys()[current_state])

var take_turns_looping: bool = false

var turn_index: int = 0

var current_player_in_turn: Player: 
	set(value): 
		var previous_player: Player = current_player_in_turn
		current_player_in_turn = value
		changed_current_player_in_turn.emit(previous_player, current_player_in_turn)
	
	
func reset() -> void: 
	take_turns_looping = false
	next_turn()
	turn_index = 0
	current_player_in_turn = null
	
	
func start_game() -> void: 
	take_turns_looping = true
	take_turns_loop()
	
	
# Turn and round counting starts at 0 
func take_turns_loop() -> void: 
	while take_turns_looping:  
		var players_in_play: Array[Player] = PlayersManager.players_in_play 
		if turn_index >= players_in_play.size(): 
			turn_index = 0
		current_player_in_turn = players_in_play[turn_index]
		turn_started.emit()
		if GameManager.debug: 
			print("PlayerTurnsManager: Current team: ", players_in_play[turn_index].team_number)
		managers.undo_history.save_current_data()
		
		await turn_is_next
		turn_ended.emit()
		# This is next round
		turn_index += 1
		managers.gameplay.game_round += 1
	
	
func is_chain_reacting() -> bool: 
	return chain_reaction.active
	
	
func is_awaiting_turn() -> bool: 
	return awaiting_turn.active
	
	
func get_previous_player_turn() -> Player: 
	var players_in_play: Array[Player] = PlayersManager.players_in_play
	var previous_player_index: int = players_in_play.find(current_player_in_turn) - 1
	var previous_player: Player = players_in_play[previous_player_index]
	return previous_player
	
	
func next_turn() -> void: 
	turn_is_next.emit()


# To do: turn index not applying properly
# Called from UndoHistorymanager
func apply_undo_changes(turn_data: TurnData) -> void:  
#	next_turn() 
	# Terminate current loop then initiate another loop
	next_turn()
	turn_index = turn_data.turn_index 
#	take_turns_loop()

