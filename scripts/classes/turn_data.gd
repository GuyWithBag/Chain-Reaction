extends Resource
class_name TurnData

# Atom Slot Name : Atom Count 
var atom_slots: Dictionary = {} 
var atom_teams_in_play: Array[AtomPlayer] = [] 
var turn_index: int

func _init(_atom_slots: Dictionary, _atom_teams_in_play: Array[AtomPlayer], _turn_index: int) -> void: 
	atom_slots = _atom_slots
	atom_teams_in_play = _atom_teams_in_play
	turn_index = _turn_index

