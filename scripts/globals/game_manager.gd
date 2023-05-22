extends Node

signal max_atoms_in_map_changed(max: int)
signal current_atoms_set(amount: int)

var max_atoms_in_map: int = 0: 
	set(value): 
		max_atoms_in_map = value
		max_atoms_in_map_changed.emit(max_atoms_in_map)

var current_atoms: int = 0: 
	set(value): 
		current_atoms = value
		current_atoms_set.emit(current_atoms)

