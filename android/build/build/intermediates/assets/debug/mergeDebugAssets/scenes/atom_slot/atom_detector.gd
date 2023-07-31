extends Node2D
class_name AtomsDetector

enum Directions {
	UP, 
	LEFT, 
	DOWN, 
	RIGHT
}

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


func get_available_directions() -> Array[int]: 
	var directions: Array[int] = []
	for raycast in raycasts: 
		var collider: Node2D = raycast.get_collider()
		if !is_instance_valid(collider): 
			continue
		var parent: Node2D = collider.owner
		if !(parent is AtomSlot): 
			continue
		if raycast.is_colliding(): 
			var direction: String = raycast.name.to_upper()
			directions.append(Directions.get(direction))
	return directions


func queue_free_all_raycasts() -> void: 
	for child in get_children(): 
		child.queue_free() 
