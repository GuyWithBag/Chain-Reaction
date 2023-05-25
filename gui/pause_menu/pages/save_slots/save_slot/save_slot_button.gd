extends Button 
class_name SaveSlotButton

# We use dictionary instead of SaveData because we are getting the save data directly from the save file and not from the save data 
var save_dict: Dictionary 
var save_file: SaveFile: 
	set(value): 
		save_file = value
		save_dict = save_file.get_as_dict()
		var game_data: Dictionary = save_dict["GameData"]
		time_played.text = game_data["time_played"]
		save_file_created.text = game_data["save_file_created"]
		save_name.text = save_dict["SaveName"] 
		chapter_name.text = LevelLoader.chapters[save_dict["LevelChapters"].keys().size() - 1].chapter_name

@onready var save_name: Label = %SaveName
@onready var chapter_name: Label = %ChapterName
@onready var player_name: Label
@onready var level_number: Label
@onready var stage_name: Label
@onready var save_file_created: Label = %SaveFileCreated
@onready var last_saved_date: Label = %LastSavedDate
@onready var time_played: Label = %TimePlayed

@onready var dates_when_data_is_saved: Array[Dictionary]


