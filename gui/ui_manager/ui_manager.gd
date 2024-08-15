extends CanvasLayer

signal gui_changed(gui: GUI)
signal gui_added(gui: GUI)
signal gui_removed(gui: GUI)

@export var debug: bool = false

var alert: PackedScene = load("res://gui/alert_gui/alert_screen/alert_screen.tscn")

var player_gui_focused: GUI 
var pause_menu_gui: GUI 

@export var gui_debugger: GUIDebugger
@export var playing: Control
@export var instanced_uis: Control
@export var transitions_manager: Control
@export var player_screen: CrossPlatformGUIManager

@export var pause_menu: GUI
@export var atom_counter_effect: GUI

@onready var touch_screen_controls: GUI
@onready var app_bar: AppBar
@onready var scoreboard: Scoreboard


func _ready() -> void:
	deactivate_playing_children()
	GameManager.current_state.child_state_entered.connect(
		func(): 
			if GameManager.is_playing() || GameManager.is_paused(): 
				layer = 4 
			else: 
				layer = 2
	)
	
	
func platform_init() -> void: 
	PlatformManager.platform_changed.connect(_on_platform_changed)
	gui_debugger.platform_init()


func _on_platform_changed(new_platform: PlatformManager.PlatformType, previous_platform: PlatformManager.PlatformType) -> void: 
	appropriate_gui_platform(PlatformManager.PlatformType.keys()[new_platform], PlatformManager.PlatformType.keys()[previous_platform])
	
	
func appropriate_gui_platform(_new_platform: String, _previous_platform: String) -> void: 
	if PlatformManager.is_mobile(): 
		touch_screen_controls = player_screen.get_gui_from_current_platform("TouchScreenControls")
		app_bar = touch_screen_controls.app_bar
		scoreboard = player_screen.get_gui_from_current_platform("Scoreboard")
		
		
func init() -> void:
	gui_debugger.init(self)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"): 
		if GameManager.pausable == true: 
			GameManager.current_state = GameManager.State.PAUSED
			UIManager.set_gui_active(UIManager.pause_menu, true)
	if Input.is_action_just_pressed("toggle_player_screen_visiblity"): 
		toggle_gui_active(player_screen)
		toggle_gui_active(atom_counter_effect)
		toggle_gui_disabled(atom_counter_effect) 
		
		
func deactivate_playing_children() -> void:
	for child in playing.get_children():
		if child.name == "PlayerScreen": 
			continue
		child.set_active(false)
	
	
func toggle_gui_disabled(gui: GUI) -> void:
	set_gui_disabled(gui, !gui.visible)
	
	
func set_gui_disabled(gui: GUI, active: bool) -> void: 
	if debug: 
		print("UIManager: %s is set disabled: %s" % [gui.name, active])
	gui.set_disabled(active)
	
	
func toggle_gui_active(gui: GUI) -> void:
	set_gui_active(gui, !gui.visible)
	
	
func set_gui_active(gui: GUI, active: bool) -> void: 
	if debug: 
		print("UIManager: %s is set active: %s" % [gui.name, active])
	if active:
		if !_can_be_activated(gui): 
			return
	gui.set_active(active)
	
	
func add_gui(gui: GUI) -> void:
	if gui.get_parent() == instanced_uis:
		return
	instanced_uis.add_child(gui)
	gui_added.emit(gui)
	gui_changed.emit(gui)
	
	
func set_and_add_gui(gui: GUI, active: bool) -> void: 
	add_gui(gui)
	set_gui_active(gui, active)
	
	
func remove_gui(gui: GUI) -> GUI:
	set_gui_active(gui, false)
	gui_removed.emit(gui)
	gui_changed.emit(gui)
	gui.queue_free()
	return gui


func create_alert(alert_message: String, yes_func: Callable = func(): , 
	no_func: Callable = func(): , yes_text: String = "Yes", 
	no_text: String = "No") -> AlertScreen: 
	
	var alert_node: AlertScreen = alert.instantiate()
	UIManager.add_gui(alert_node)
	
	var yes_button: Button = alert_node.yes
	var no_button: Button = alert_node.no
	alert_node.alert_label.text = alert_message
	yes_button.text = yes_text
	no_button.text = no_text
	
	yes_button.pressed.connect(yes_func, CONNECT_ONE_SHOT)
	no_button.pressed.connect(no_func, CONNECT_ONE_SHOT)
	return alert_node


func _can_be_activated(gui: GUI) -> bool: 
	if _is_in_game_gui(gui): 
		if GameManager.current_state == GameManager.State.IN_GAME: 
			return true
	elif _is_pause_menu_gui(gui): 
		GameManager.current_state = GameManager.State.PAUSED
		if GameManager.current_state == GameManager.State.PAUSED: 
			return true
	return false


func _is_in_game_gui(gui: GUI) -> bool: 
	match gui.gui_type:
		GUI.GUIType.PLAYER_GUI: 
			return true
		GUI.GUIType.CINEMATIC: 
			return true
		GUI.GUIType.WIDGET: 
			return true
	return false
	
	
func _is_pause_menu_gui(gui: GUI) -> bool: 
	match gui.gui_type:
		GUI.GUIType.PAUSE_MENU: 
			return true
		GUI.GUIType.WIDGET: 
			return true
	return false
	
