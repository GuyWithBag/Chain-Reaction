extends Resource
class_name AdID

@export var android_id: String
@export var ios_id: String

func set_android_id(id: String) -> AdID: 
	android_id = id
	return self


func set_ios_id(id: String) -> AdID: 
	ios_id = id
	return self
	
	
func get_id() -> String: 
	if OS.get_name() == "Android":
		return android_id
	elif OS.get_name() == "iOS":
		return ios_id
	return ""

