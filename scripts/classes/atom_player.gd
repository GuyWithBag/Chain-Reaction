extends Resource
class_name AtomPlayer

signal total_atoms_changed(previous_count: int, new_count: int)

@export var group_name: String: 
	get: 
		return "Player %s" % team_number 
		
@export var team_number: int 
@export var team_color: Color

var first_atom_has_been_placed: bool = false

var total_atoms: int: 
	set(value): 
		var prev_value: int = total_atoms
		total_atoms = value
		if first_atom_has_been_placed == false && total_atoms == 1: 
			first_atom_has_been_placed = true 
			return
		total_atoms_changed.emit(prev_value, total_atoms)

func _init(_team_number: int, _team_color: Color) -> void: 
	team_number = _team_number
	team_color = _team_color


func reset() -> void: 
	first_atom_has_been_placed = false 
	total_atoms = 0 
	
	
