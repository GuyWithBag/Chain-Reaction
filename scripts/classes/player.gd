extends Resource
class_name Player

signal current_total_atoms_changed(previous_count: int, new_count: int)

@export var group_name: String: 
	get: 
		return "Player %s" % team_number 
		
@export var team_number: int 
@export var team_color: Color

var first_atom_has_been_placed: bool = false

var current_total_atoms: int = 0: 
	set(value): 
		var prev_value: int = current_total_atoms
		current_total_atoms = value
		if first_atom_has_been_placed == false && current_total_atoms == 1: 
			first_atom_has_been_placed = true 
		current_total_atoms_changed.emit(prev_value, current_total_atoms)
		
var total_atoms_added: int = 0

func _init(_team_number: int, _team_color: Color) -> void: 
	team_number = _team_number
	team_color = _team_color


func reset() -> void: 
	first_atom_has_been_placed = false 
	current_total_atoms = 0 
	
	
