extends Node2D

const loading_scene_path = "res://loading/LoadingScreen.tscn"

func _ready():
    call_deferred("change_scene")

func change_scene():
    get_tree().change_scene_to_file(loading_scene_path)
