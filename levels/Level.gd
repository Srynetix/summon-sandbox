extends Node3D
class_name GameLevel

var game: GameGameScreen
var player: GamePlayerController

var _lights_shown: bool

func _ready() -> void:
    # Enable all HelpZones
    for node in get_tree().get_nodes_in_group("HelpZone"):
        var help_zone := node as GameHelpZone
        help_zone.player_entered.connect(func(text):
            game.show_help("")
            game.show_help(text)
        )

        # Exclude zones from player raycast
        player.weapon.raycast.add_exception(help_zone)

func hide_help_zones() -> void:
    for node in get_tree().get_nodes_in_group("HelpZone"):
        var help_zone := node as GameHelpZone
        help_zone.visible = false
        help_zone.monitoring = false

func show_help_zones() -> void:
    for node in get_tree().get_nodes_in_group("HelpZone"):
        var help_zone := node as GameHelpZone
        help_zone.visible = true
        help_zone.monitoring = true

func show_lights() -> void:
    for node in get_tree().get_nodes_in_group("GameLight"):
        node.visible = true
    _lights_shown = true

func hide_lights() -> void:
    for node in get_tree().get_nodes_in_group("GameLight"):
        node.visible = false
    _lights_shown = false

func toggle_lights() -> void:
    if _lights_shown:
        hide_lights()
    else:
        show_lights()