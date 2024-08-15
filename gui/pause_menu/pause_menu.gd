extends GUI


enum Pages {
	MAIN, 
}

@onready var pages: TabContainer = get_node("CenterContainer/TabContainer") 
@onready var main: ReferenceRect = get_node("CenterContainer/TabContainer/Main")


func _ready() -> void: 
	UIManager.set_gui_active(self, false)


func set_active(value: bool): 
	super.set_active(value)
	GameManager.pause_game(value) 
	if value: 
		GameManager.state_chart.send_event("pause")
	else: 
		GameManager.state_chart.send_event("play")


func _input(event: InputEvent) -> void: 
	if !active: 
		return
	if event.is_action_pressed("ui_cancel"): 
		if pages.current_tab <= 0: 
			UIManager.set_gui_active(self, false)
			return
		pages.current_tab -= 1
	
	
