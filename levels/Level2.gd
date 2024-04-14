extends GameLevel

@onready var weapon_container := $WeaponContainer as Area3D

func _ready() -> void:
    super._ready()

    player.enable_movement = true
    player.enable_weapon = false
    player.enable_ring = true

    game.show_help(
        "Hey, that's a gun.\n" +
        "Take it, it will be helpful."
    )

    weapon_container.area_entered.connect(func(area):
        if area.is_in_group("PlayerController"):
            weapon_container.queue_free()
            player.enable_weapon = true
            game.show_glitch()

            game.show_help(
                "There you go! Use left-click to shoot!\n" +
                "Destroy this box in the way."
            )
    )
