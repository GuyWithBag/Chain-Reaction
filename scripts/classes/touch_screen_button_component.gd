@tool
extends Node
class_name TouchScreenButtonComponent

@export var material_icon: String: 
	set(value): 
		material_icon = value
		if material_icons_url.has(material_icon): 
			var material_icon_url: String = material_icon.to_snake_case()
			if owner is Button: 
				owner.icon = load(material_icons_url[material_icon_url])
			elif owner is TextureButton: 
				owner.texture_normal = load(material_icons_url[material_icon_url])
		else: 
			if owner is Button: 
				owner.icon = null
			elif owner is TextureButton: 
				owner.texture_normal = null
				
@export var event_action: String



var material_icons_url: Dictionary = {
	"menu" : "res://material_icons/menu.svg", 
	"undo" : "res://material_icons/undo.svg"
}


# In order for this to work, you must add an InputEvenActionKey "nothing" in the input map
func _on_pressed() -> void:
	if event_action != "": 
		print("TouchScreenButton: event_action: ", event_action)
		#var input_event_action: InputEventAction = InputEventAction.new()
		#input_event_action.action = "nothing"
		#input_event_action.pressed = true
		#Input.action_press(event_action, 1)
		#Input.action_release(event_action)
		#Input.parse_input_event(input_event_action)
		var _event_action: InputEventAction = InputEventAction.new()
		_event_action.action = event_action
		_event_action.pressed = true
		Input.parse_input_event(_event_action)

