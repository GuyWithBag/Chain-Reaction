extends CrossPlatformGUIManager

var touch_screen_controls: GUI

func _on_platform_changed(new_platform, previous_platform) -> void: 
	super._on_platform_changed(new_platform, previous_platform)
	touch_screen_controls = mobile.get_node("TouchScreenControls")


