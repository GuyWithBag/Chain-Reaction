extends HBoxContainer
class_name HGridContainer

@export var max_rows: int = 2

var rows: Array[Node] = []: 
	get: 
		return get_children()


func add_slot(control: Control) -> void: 
	var rows_size: int = rows.size()
	if rows_size == 0: 
		add_row()
		
		
func add_row() -> void: 
	var v_box_container: VBoxContainer = VBoxContainer.new()
	add_child(v_box_container) 
	rows.append(v_box_container)
	
