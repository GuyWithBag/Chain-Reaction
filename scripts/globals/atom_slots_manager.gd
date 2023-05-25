extends Node

var tilemap: TileMap 

var initialized: bool = false

func init() -> void: 
	if initialized: 
		return 
	tilemap = get_tree().current_scene.tilemap
	for atom_slot in tilemap.get_children(): 
		atom_slot.atom_stack.init()
	initialized = true


#func get_total_max_atom_stack() -> int: 
#	var total_max_atom_stack: int = 0 
#	for atom_slot in tilemap.get_children(): 
#		total_max_atom_stack += atom_slot.atom_stack.max_atom_stack
#	return total_max_atom_stack
#
#
#func is_tilemap_full_of_cells() -> bool: 
#	var total_atom_count: int = 0
#	for atom_slot in tilemap.get_children(): 
#		total_atom_count += atom_slot.atom_stack.atom_count
#	if total_atom_count >= get_total_max_atom_stack(): 
#		return true
#	return false

