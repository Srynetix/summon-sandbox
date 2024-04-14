extends GameLevel

func _ready() -> void:
    hide_lights()

    GameData.bomb_unlocked = true
    GameData.block_unlocked = false
    GameData.light_unlocked = true
    GameData.jump_unlocked = true
    GameData.ball_unlocked = false
    player.weapon.enable_erase_mode = false

    game.show_help(
        "Well, it's really dark here.\n" +
        "Do you have a flashlight?\n" +
        "...No?"
    )
