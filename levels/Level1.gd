extends GameLevel

@onready var summoner_ring_wrapper := %SummoningRingWrapper as Area3D
@onready var _pick_sfx := $PickSFX as AudioStreamPlayer

func _ready() -> void:
    super._ready()

    summoner_ring_wrapper.area_entered.connect(func(area):
        if area.is_in_group("PlayerController"):
            _pick_sfx.play()
            summoner_ring_wrapper.queue_free()
            player.enable_ring = true
            game.show_glitch()

            await game.show_help(
                "Great! Now, aim somewhere and check your ring using the [color=green]right-click[/color] button on your mouse.\n" +
                "Use the [color=green]mouse wheel[/color] (or [color=green]W and S keys[/color]) to select a shape.\n" +
                "Confirm using the [color=green]left-click button[/color] on the [color=blue]three inner rings[/color]."
            )

            show_help_zones()

            await game.show_help(
                "I don't really know the combinations, so if it does nothing, don't panic.\n" +
                "Just find a way to exit this area."
            )
    )

    player.enable_weapon = false
    player.enable_ring = false
    player.enable_movement = false
    player.enable_look = false
    player.weapon.enable_erase_mode = false

    GameData.bomb_unlocked = true
    GameData.block_unlocked = false
    GameData.light_unlocked = false
    GameData.jump_unlocked = false
    GameData.ball_unlocked = false

    hide_help_zones()

    await game.show_help(
        "Hello, and welcome.\n" +
        "In this game, you will need to use your brain to escape each level.\n" +
        "Your brain, and a special tool... that you can find just in front of you.\n\n" +
        "The [color=yellow][wave]Summoning Ring[/wave][/color]."
    )

    player.enable_movement = true
    player.enable_look = true

    await game.show_help(
        "Oh yeah, I almost forgot.\n" +
        "To move, you can use the [color=green]W/A/S/D[/color] keys, and use your [color=green]mouse[/color] to look around.\n" +
        "You can jump [color=yellow]twice[/color] using [color=green]Space[/color].\n" +
        "And you can dash by moving two times quickly in one direction."
    )
