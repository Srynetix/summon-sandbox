extends Control
class_name GameBootScreen

func _ready() -> void:
    GameSceneTransitioner.fade_to_cached_scene(LoadCache, "TitleScreen")