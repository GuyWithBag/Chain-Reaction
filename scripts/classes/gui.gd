# All gui related things that can be controled by the UIManager. 
# All code that shows the gui must start at set_active(), also so it is less prone to bugs. 
extends Control 
class_name GUI

signal activated 
signal deactivated

# GUIType are for identifying what types of guis are focused. 

enum GUIType {
	PAUSE_MENU, 
	PLAYER_GUI, 
	TUTORIAL, 
	CINEMATIC, 
	# Widget is a type that can be added whatever gui_type is focused. 
	WIDGET 
} 

var _initialized: bool = false

@export var active: bool = false: set = set_active

@export var inactive_on_ready = true
@export var disabled: bool = false
@export var gui_type: GUIType


#func _ready() -> void: 
	#if inactive_on_ready: 
		#set_active(false)

## Activateds and makes the gui visible. Never use this method, only use UIManager.set_gui_active. 
func set_active(value: bool) -> void: 
	if disabled: 
		return
	if value && _activate_condition(): 
		active = true
		_activated()
		activated.emit()
		_initialized = true
	elif !value && _deactivate_condition(): 
		if _initialized: 
			active = false
			_deactivated()
			deactivated.emit()
		if inactive_on_ready && !_initialized: 
			visible = false
			active = false
			_initialized = true
	
	
#func activate() -> void: 
	#active = true
	#_activated()
	#activated.emit()
	#
	#
#func deactivate() -> void: 
	#active = false
	#_deactivated()
	#deactivated.emit()
	
	
func _activated() -> void: 
	visible = true
	
	
func _deactivated() -> void: 
	visible = false
	
	
func _activate_condition() -> bool: 
	return true
	
	
func _deactivate_condition() -> bool: 
	return true
	
