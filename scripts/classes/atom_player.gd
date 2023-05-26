extends Resource
class_name AtomPlayer

signal total_atoms_changed(previous_count: int, new_count: int)

@export var team_number: int 
@export var team_color: Color

var total_atoms: int: 
	set(value): 
		var prev_value: int = total_atoms
		total_atoms = value
		total_atoms_changed.emit(prev_value, total_atoms)

func _init(_team_number: int, _team_color: Color) -> void: 
	team_number = _team_number
	team_color = _team_color
