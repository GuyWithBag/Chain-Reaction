extends CanvasLayer
class_name GUIDebugger

@export var highlight_gui: bool = false

#var current_platform_label_text: String = "CurrentPlatform: %s" 

@onready var gui_highlighter: Control = get_node("GUIHighlighter")
#@onready var current_platform_label: Label =  $CurrentPlatformLabel


func platform_init() -> void: 
#	PlatformManager.platform_changed.connect(
#		func(_new_platform, _previous_platform): 
#			current_platform_label.text = current_platform_label_text % PlatformManager.current_platform_type_string
#	)
	pass
	
func init(ui_manager: Object) -> void: 
	if highlight_gui: 
		_connect_children_mouse_signals(ui_manager)


func highlight_debug_ui(parent: Object) -> void: 
	_connect_children_mouse_signals(parent)
	

func _connect_children_mouse_signals(parent: Object) -> void:
	var children: Array[Node] = parent.get_children()
	for child in children:
#		print("\nchildren: ", children, "\n || key: ", key)
#		print(" || data: ", child)
		if child is Control:
			child.mouse_entered.connect(func(): gui_highlighter.highlight_gui(true, child))
			child.mouse_exited.connect(func(): gui_highlighter.highlight_gui(false, child))
			child.hidden.connect(func(): gui_highlighter.highlight_gui(false))
		if child.get_child_count() > 0:
			_connect_children_mouse_signals(child)

