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
	set_process_unhandled_input(value)
	if value: 
		GameManager.current_state = GameManager.State.PAUSED
		UIManager.set_process_input(false)
	else: 
		GameManager.current_state = GameManager.State.IN_GAME
		UIManager.set_process_input(true)


func _input(_event: InputEvent) -> void: 
	if Input.is_action_just_pressed("ui_cancel"): 
		if pages.current_tab <= 0: 
			UIManager.set_gui_active(self, false)
			UIManager.set_process_input(true)
			return
		pages.current_tab -= 1
	
	
