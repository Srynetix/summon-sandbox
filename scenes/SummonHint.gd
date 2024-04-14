@tool
extends MeshInstance3D
class_name GameSummonHint

@export_multiline var text := "": set = _set_text

@onready var _text_mesh: TextMesh = mesh as TextMesh

func _ready() -> void:
    _set_text(text)

func _set_text(value: String) -> void:
    text = value

    if _text_mesh == null:
        await self.ready

    _text_mesh.text = text