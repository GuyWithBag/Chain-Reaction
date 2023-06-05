extends Resource
class_name AtomSlotData 

var atom_count: int 
var atom_player: AtomPlayer
var current_state: AtomSlotBaseState

func _init(_atom_count: int, _atom_player: AtomPlayer, _current_state: AtomSlotBaseState) -> void: 
	atom_count = _atom_count 
	atom_player = _atom_player
	current_state = _current_state
