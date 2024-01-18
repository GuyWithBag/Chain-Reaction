extends GUI
class_name CrossPlatformGUIManager

@export var current_platform_type: PlatformManager.PlatformType: 
	set(value): 
		current_platform_type = value
		if is_instance_valid(mode): 
			if current_platform_type == 0:
				return
			mode.current_tab = (current_platform_type - 1)

@onready var mode: TabContainer = $Mode

@onready var pc: GUI = mode.get_node("PC")
@onready var mobile: GUI = mode.get_node("MOBILE")
@onready var console: GUI = mode.get_node("CONSOLE")


func _ready() -> void: 
	# This is executed if the GUI was not initiated with the UIManager
	if PlatformManager.platform_changed.is_connected(_on_platform_changed) == false: 
		platform_init()
		appropriate_gui(PlatformManager.current_platform_type)


func platform_init() -> void: 
	PlatformManager.platform_changed.connect(_on_platform_changed)


func get_gui_from_current_platform(path: NodePath) -> Control: 
	return get_node("Mode/%s/%s" % [PlatformManager.current_platform_type_string, path])
	
	
func _on_platform_changed(new_platform: PlatformManager.PlatformType, _previous_platform: PlatformManager.PlatformType) -> void: 
	appropriate_gui(new_platform)


func appropriate_gui(new_platform: PlatformManager.PlatformType) -> void: 
	current_platform_type = new_platform
	
	
