extends GUI


func _on_back_pressed() -> void:
	save()


func save() -> void: 
	LocalDatabase.save_settings() 
	LocalDatabase.save_settings_to_file() 
