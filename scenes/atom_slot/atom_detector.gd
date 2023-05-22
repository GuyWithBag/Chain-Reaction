extends Node2D
class_name AtomsDetector

@onready var raycasts: Array[Node] = get_children()

func init(parent: Node2D) -> void: 
	for raycast in raycasts: 
		var exception: Area2D = parent.get_node("Hitbox")
		raycast.add_exception(exception)


func get_slot_in_all_directions() -> Array[AtomSlot]: 
	var atom_slots: Array[AtomSlot] = [] 
	for raycast in raycasts: 
		var collider: Node2D = raycast.get_collider()
		if !is_instance_valid(collider): 
			continue
		var parent: Node2D = collider.owner
		if !(parent is AtomSlot): 
			continue
		atom_slots.append(parent)
	return atom_slots


func get_available_directions() -> Array[String]: 
	var directions: Array[String] = []
	for raycast in raycasts: 
		var collider: Node2D = raycast.get_collider()
		if !is_instance_valid(collider): 
			continue
		var parent: Node2D = collider.owner
		if !(parent is AtomSlot): 
			continue
		if raycast.is_colliding(): 
			directions.append(raycast.name.to_upper())
	return directions
	
	
func is_tilemap_full() -> bool: 
	for atom_slot in get_slot_in_all_directions(): 
		if atom_slot.atom_stack.is_maxxed(): 
			return false
	return false
			
			
func return_all_max_atom_stack() -> Array[int]: 
	var max_atom_counts: Array[int] = [] 
#	var exceptions: Array[AtomSlot] = []
#	for atom_slot in get_slot_in_all_directions(): 
#		print(exceptions)
#		if atom_slot in exceptions: 
#			continue
#		var max_atom_stack: int = atom_slot.atom_stack.max_atom_stack
#		max_atom_counts.append(max_atom_stack)
#		max_atom_counts.append_array(atom_slot.atom_detector.return_all_max_atom_stack())
#		exceptions.append(atom_slot)
	return max_atom_counts
	
	
