extends GameLevel

func _ready() -> void:
    super._ready()

    game.show_help(
        "Okay dude, you are on your own now.\n" +
        "I did not have much time to write more levels for you,\n" +
        "so here's my last level.\n" +
        "Play as you wish, and jump in the void when you are finished to end the game."
    )

    GameData.jump_unlocked = true
    GameData.bomb_unlocked = true
    GameData.block_unlocked = true
    GameData.ball_unlocked = true
    GameData.light_unlocked = true
    player.weapon.enable_erase_mode = true