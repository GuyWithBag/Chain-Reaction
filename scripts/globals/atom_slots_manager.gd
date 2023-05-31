extends Node

signal atom_slot_exploded(atom_slot: AtomSlot)

signal atom_removed
signal atom_added(atom_amount_added: int, new_player: AtomPlayer)

var tilemap: TileMap 

var initialized: bool = false

# AtomSlotName : AtomCount 
var data: Dictionary = {}


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


func get_all_atom_slots() -> Dictionary: 
	var atom_slots: Dictionary = {}
	for atom_slot in get_tree().get_nodes_in_group("AtomSlot"): 
		atom_slots[atom_slot.name] = atom_slot.atom_stack.atom_count 
	return atom_slots
	
	
func apply_undo_changes() -> void: 
	pass
