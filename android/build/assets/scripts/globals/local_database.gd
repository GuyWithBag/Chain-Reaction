extends Node

signal saved_settings(save_data: Dictionary) 
signal saved_settings_to_file(save_data: Dictionary) 

signal loaded_settings(load_data: Dictionary) 
signal loaded_settings_from_file(load_data: Dictionary) 

var path: String = "user://ChainReactionAtomRevampedSupreme/" 

var settings_file_name: String = "settings.json"
var settings: Dictionary = {}
var data: Dictionary = {} 


func _ready() -> void: 
	load_settings_from_file()  


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST: 
		LocalDatabase.save_settings() 
		LocalDatabase.save_settings_to_file() 
		
		
func save_settings_to_file() -> void: 
	DirAccess.make_dir_absolute(path)
	var file: FileAccess = FileAccess.open(path + settings_file_name, FileAccess.WRITE) 
	file.store_string(JSON.stringify(settings)) 
	file.close() 
	saved_settings_to_file.emit() 


func save_settings() -> void: 
	settings = {
		"AtomPlayersManager" : AtomPlayersManager.save_settings(), 
		"UndoHistoryManager" : UndoHistoryManager.save_settings(), 
		"AudioServer" : audio_server_save_settings(), 
		"TranslationServer" : TranslationServer.get_locale()
	}
	saved_settings.emit(settings)
	
	
func load_settings_from_file() -> void: 
	var file_path: String = path + settings_file_name
	if !FileAccess.file_exists(file_path): 
		return
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ) 
	var text: String = file.get_as_text() 
	if text.is_empty(): 
		printerr("LocalDatabase: Data in file is missing. ")
		return
	var json: Dictionary = JSON.parse_string(text) 
	load_settings(json) 
	file.close() 
	loaded_settings_from_file.emit(json)
	
	
func load_settings(load_data: Dictionary) -> void: 
	if load_data.is_empty(): 
		print("localDatabase: data is empty") 
		return
	AtomPlayersManager.load_settings(load_data["AtomPlayersManager"]) 
	UndoHistoryManager.load_settings(load_data["UndoHistoryManager"]) 
	var option_list_tile_game_rules: OptionListTile = get_tree().get_first_node_in_group("OptionListTileGameRules") 
	TranslationServer.set_locale(load_data["TranslationServer"]) 
	option_list_tile_game_rules.init()
	audio_server_load(load_data) 
	loaded_settings.emit(load_data) 
	
	
func audio_server_save_settings() -> Dictionary: 
	var _data: Dictionary = {} 
	for count in AudioServer.bus_count: 
		_data[AudioServer.get_bus_name(count)] = AudioServer.get_bus_volume_db(count) 
	return _data 
	
	
func audio_server_load(load_data: Dictionary) -> void: 
	var audio_server: Dictionary = load_data["AudioServer"] 
	for count in AudioServer.bus_count: 
		AudioServer.set_bus_volume_db(count, audio_server[AudioServer.get_bus_name(count)]) 
	for slider in get_tree().get_nodes_in_group("BusVolumeSlider"): 
		slider.init() 
