extends Node

signal atom_slot_finished_saving_data(atom_slot: AtomSlotData)

signal atom_slot_exploded(atom_slot: AtomSlot)

signal atom_removed
signal atom_added(atom_amount_added: int)

var tilemap: TileMap 

var initialized: bool = false

var all_atom_slots: Array[Node] = []: 
	get: 
		return get_tree().get_nodes_in_group("AtomSlot")
# AtomSlotName : AtomSlot
var atom_slots_saved_data: Dictionary = {}


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
	
	
func reset() -> void: 
	atom_slots_saved_data.clear()
	
	
# Called from UndoHistorymanager
func apply_undo_changes(turn_data: TurnData) -> void: 
	for atom_slot in all_atom_slots: 
		if turn_data.atom_slots.has(atom_slot.name): 
			atom_slot.apply_undo_changes(turn_data.atom_slots[atom_slot.name])
		else: 
			atom_slot.apply_undo_changes(null)
	atom_slots_saved_data = turn_data.atom_slots 
	
	


