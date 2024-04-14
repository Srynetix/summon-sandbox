extends Node3D

func _ready() -> void:
    var tween = get_tree().create_tween()
    tween.tween_property(GameMusic, "volume_db", -80, 3).from(-15)
    await tween.finished

    GameMusic.stop()
    GameMusic.volume_db = -15

    GameSceneTransitioner.fade_to_cached_scene(LoadCache, "TitleScreen")