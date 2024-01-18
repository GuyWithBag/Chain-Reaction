extends Button


@export var page_container: TabContainer
@export var go_to_page: Control
@export var press_on_go_back_request: bool = false
		

func _on_pressed() -> void: 
	if !is_visible_in_tree(): 
		return
	var pages: Array[Node] = page_container.get_children()
	var page_index: int = pages.find(go_to_page)
	page_container.current_tab = page_index
	
	
func _notification(what: int) -> void: 
	if what == Node.NOTIFICATION_WM_GO_BACK_REQUEST: 
		if press_on_go_back_request: 
			_on_pressed()


