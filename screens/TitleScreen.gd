extends Node3D
class_name GameTitleScreen

@onready var _start_button := %StartButton as Button

func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    _start_button.pressed.connect(func(): GameSceneTransitioner.fade_to_cached_scene(LoadCache, "GameScreen"))
