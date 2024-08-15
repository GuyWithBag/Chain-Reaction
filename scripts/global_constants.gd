extends Node

const UNIT_SIZE: int = 32

var display_screen_size: Vector2 = DisplayServer.window_get_size()
var original_screen_size: Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
