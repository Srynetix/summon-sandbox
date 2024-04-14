extends Area3D
class_name GameHelpZone

signal player_entered(text: String)

@export_multiline var text: String

func _ready() -> void:
    add_to_group("HelpZone")

    area_entered.connect(func(area):
        if area.is_in_group("PlayerController"):
            player_entered.emit(text)
    )
