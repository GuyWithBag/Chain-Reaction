extends GUI

var selected_button: LanguagesButton 
var languages_button: PackedScene = load("res://gui/languages_options/widgets/languages_button.tscn") 
var loaded_locales: PackedStringArray = TranslationServer.get_loaded_locales()

@onready var list: VBoxContainer = get_node("PanelContainer/MarginContainer/VBoxContainer/Panel/ScrollContainer/List")


func _ready() -> void: 
	for locale in loaded_locales: 
		var button: Button = languages_button.instantiate() 
		list.add_child(button)
		var locale_name: String = TranslationServer.get_locale_name(locale) 
		button.text = locale_name
		button.locale = locale 
		button.pressed.connect(_on_button_pressed.bind(button))


func _on_button_pressed(button: LanguagesButton) -> void: 
	var prev_selected: LanguagesButton = selected_button
	if prev_selected: 
		prev_selected.button_pressed = false 
	selected_button = button


func _on_accept_pressed() -> void:
	TranslationServer.set_locale(selected_button.locale) 
	match selected_button.locale: 
		"ja": 
			pass
	LocalDatabase.save_settings() 
	LocalDatabase.save_settings_to_file() 


#func se_theme_default_font(font_Size: int) -> void: 
#	var _theme = load("res://themes/main_theme/main_theme.tres")
#	_theme.default_font_size = font_Size
	
	
	
