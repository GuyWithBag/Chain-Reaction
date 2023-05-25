extends Button


@export var page_container: TabContainer
@export var go_to_page: Control


func _on_pressed() -> void:
	var pages: Array[Node] = page_container.get_children()
	var page_index: int = pages.find(go_to_page)
	page_container.current_tab = page_index
	
	
