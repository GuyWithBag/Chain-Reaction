extends Node

signal history_resetted()

signal turn_data_removed(turn_data: TurnData)
signal turn_data_added(turn_data: TurnData)

var history: Array[TurnData] = [] 


func reset_history() -> void: 
	history.clear()
	history_resetted.emit()


func add_turn_data(turn_data: TurnData) -> void: 
	history.append(turn_data)
	turn_data_added.emit(turn_data)
	
	
func pop_back_turn_data() -> TurnData: 
	turn_data_removed.emit()
	return history.pop_back()

