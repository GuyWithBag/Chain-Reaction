extends Resource
class_name AtomSlotData 

var atom_count: int 
var player: Player
var current_state: AtomSlotBaseState

func _init(_atom_count: int, _player: Player, _current_state: AtomSlotBaseState) -> void: 
	atom_count = _atom_count 
	player = _player
	current_state = _current_state
