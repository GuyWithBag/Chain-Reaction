extends CanvasLayer

signal started_loading
signal finished_loading

#@onready var progress_bar:ProgressBar = $ProgressBar

var to_scene_path: String = ""
var show_continue_button: bool

var progress: Array = []
var scene_load_status: int = 0
var has_finished_loading: bool = false


func _init() -> void: 
	set_process(false)
	init()


func init() -> void: 
	to_scene_path = LoadingScreen.to_scene_path 
	show_continue_button = LoadingScreen.show_continue_button
	started_loading.emit()
	finished_loading.connect(_on_finished_loading) 
	ResourceLoader.load_threaded_request(to_scene_path) 
	set_process(true)


func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(to_scene_path, progress)
#	progress_bar.value = progress[0] * 100
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED && has_finished_loading == false:
#		$Continue_Button.visible = true
		finished_loading.emit()
		set_process(false)


func _on_continue_button_pressed():
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		_change_scene() 
	else:
		print("Scene not loaded or in progress")


func _on_finished_loading() -> void: 
	_change_scene()
	
	
func _change_scene() -> void: 
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(to_scene_path))
	queue_free()
