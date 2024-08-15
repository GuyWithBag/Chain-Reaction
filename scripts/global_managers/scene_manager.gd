extends Node

var next_scene_path: String
var loading_screen_instance: LoadingScreen
var load_status: ResourceLoader.ThreadLoadStatus

@onready var loading_screen: PackedScene = preload("res://gui/loading_screen/loading_screen.tscn")

func _init() -> void: 
	set_process(false)


func _ready() -> void: 
	set_process(false)


func _process(_delta: float) -> void: 
	#var current_scene: Node = get_tree().current_scene
	
	match load_status:
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE: 
			push_error("Error: Cannot load, resource is invalid.")
			set_process(false)
		# For loading screens with progress bars
#			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
#				loading_screen_instance.get_node("Control/ProgressBar").value = load_progress[0]
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED:
			push_error("Error: Loading failed!")
			set_process(false)
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			var next_scene: PackedScene = ResourceLoader.load_threaded_get(next_scene_path)
#				var next_scene_instance: Node = next_scene.instantiate() 
#				get_tree().get_root().call_deferred("add_child", next_scene_path_instance)
#				get_tree().unload_current_scene()
#				get_tree().call_deferred("set_current_scene", next_scene_path_instance)
			get_tree().change_scene_to_packed(next_scene)
			if is_instance_valid(loading_screen_instance): 
				loading_screen_instance.end_load() 
#				printerr(get_tree().current_scene) 
			set_process(false)


func change_scene_to_file(_next_scene_path: String) -> void:
	#get_tree().change_scene_to_file(next_scene_path)
	#return
	next_scene_path = _next_scene_path
	
	if loading_screen_instance == null: 
		loading_screen_instance = loading_screen.instantiate()
	
		get_tree().get_root().call_deferred("add_child", loading_screen_instance)
		loading_screen_instance.call_deferred("init", "fade_in", "fade_out")
	#loading_screen_instance.init("fade_in", "fade_out")
	# Finds the path to the scene file. (needs to fetch from GAME SCENES if applicable)
	@warning_ignore("unused_variable")
	var loader_error: Error
	var load_path: String = next_scene_path
	
	if ResourceLoader.exists(load_path): 
		loader_error = ResourceLoader.load_threaded_request(load_path, "", true)
	else:
		print("Error: Attempting to load non-existent file!")
	if is_instance_valid(loading_screen_instance): 
		await loading_screen_instance.ready_to_load 
	#current_scene.queue_free() 
	
	var load_progress: Array = []
	load_status = ResourceLoader.load_threaded_get_status(load_path, load_progress)
	
	set_process(true)
