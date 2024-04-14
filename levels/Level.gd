extends Node3D
class_name GameLevel

var game: GameGameScreen
var player: GamePlayerController

func _ready() -> void:
    # Enable all HelpZones
    for node in get_tree().get_nodes_in_group("HelpZone"):
        var help_zone := node as GameHelpZone
        help_zone.player_entered.connect(func(text):
            game.show_help("")
            game.show_help(text)
        )
