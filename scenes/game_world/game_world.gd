extends Node2D


# TODO: Have it so that it will stop being able to add when map is already full
# Have it count the total number of atoms present in each team and total of all of them

func _ready() -> void: 
	GameManager.max_atoms_in_map_changed.connect(
		func(x): 
			$Label.text = str(x)
	)
	GameManager.current_atoms_set.connect(
		func(x): 
			$Label2.text = str(x)
	)
