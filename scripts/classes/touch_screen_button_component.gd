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
	"menu" : "res://gui/material_icons/menu.svg", 
	"undo" : "res://gui/material_icons/undo.svg"
}

func _ready() -> void: 
	(owner as BaseButton).pressed.connect(_on_pressed)


func _on_pressed() -> void:
	if event_action != "": 
		var input_event_action: InputEventAction = InputEventAction.new()
		input_event_action.action = "nothing"
		input_event_action.pressed = true
		Input.parse_input_event(input_event_action)
		Input.action_press(event_action, 1)

