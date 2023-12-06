extends Node2D

const target_scene_path = "res://main/drag_and_drop.tscn"

var loading_status : int
var progress : Array[float]
var cur_index : int = 0
var last_tick : int = 0

@onready var loadings = []

func _ready() -> void:
    for i in range(9):
        loadings.append(get_node("Loading-" + str(i)))
    # Request to load the target scene:
    ResourceLoader.load_threaded_request(target_scene_path)
    
func _process(_delta: float) -> void:
    # Update the status:
    loading_status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)

    var new_index = progress[0] * 10
    if new_index > cur_index:
        var now : int = Time.get_ticks_msec()
        if cur_index + 1 < len(loadings) and now - 250 > last_tick:
            last_tick = now
            cur_index += 1
        for i in range(len(loadings)):
            loadings[i].visible = cur_index == i

    # Check the loading status:
    match loading_status:
        #ResourceLoader.THREAD_LOAD_IN_PROGRESS:
        ResourceLoader.THREAD_LOAD_LOADED:
            if progress[0] == 1 and cur_index >= len(loadings) - 1:
                get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(target_scene_path))
        ResourceLoader.THREAD_LOAD_FAILED:
            # Well some error happend:
            print("Error. Could not load Resource")
