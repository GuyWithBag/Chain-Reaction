extends Resource
class_name TurnData

# AtomSlotName : AtomSlot
var atom_slots: Dictionary = {}
var players_in_play: Array[Player] = [] 
var turn_index: int = 0
var game_round: int = 0


func _init(_atom_slots: Dictionary, _players_in_play: Array[Player], _turn_index: int, _game_round: int) -> void: 
	atom_slots = _atom_slots
	players_in_play = _players_in_play
	turn_index = _turn_index
	game_round = _game_round


func show_details() -> void: 
	print("
	
		Game round: %s, 
		Atom Players in play: %s, 
		Turn Index: %s, 
		Atom Slots: %s, 
		
	" % [game_round, players_in_play, turn_index, atom_slots])
