extends GameLevel

@onready var summoner_ring_wrapper := %SummoningRingWrapper as Area3D

func _ready() -> void:
    super._ready()

    game.show_help(
        "Hello, and welcome.\n" +
        "In this game, you will need to use your brain to escape each level.\n" +
        "Your brain, and a special tool... that you can find just in front of you.\n\n" +
        "The [wave]Summoning Ring[/wave]."
    )

    player.enable_movement = false
    player.enable_weapon = false
    player.enable_ring = false

    await get_tree().create_timer(1.0).timeout

    player.enable_movement = true

    summoner_ring_wrapper.area_entered.connect(func(area):
        if area.is_in_group("PlayerController"):
            summoner_ring_wrapper.queue_free()
            player.enable_ring = true
            game.show_glitch()

            game.show_help(
                "Great! Now, aim somewhere and check your ring using the right-click button on your mouse.\n" +
                "Use the mouse wheel (or Z and S keys) to select a shape.\n" +
                "Confirm using the left-click button on the three inner rings.\n" +
                "Who knows what you can do with a special combination.\n" +
                "Find a way to exit this area."
            )
    )
