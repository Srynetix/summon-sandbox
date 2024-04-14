extends GameLevel

@onready var weapon_container := $WeaponContainer as Area3D
@onready var _pick_sfx := $PickSFX as AudioStreamPlayer

func _ready() -> void:
    super._ready()

    player.enable_movement = true
    player.enable_weapon = false
    player.enable_ring = true
    player.enable_look = true
    player.weapon.enable_erase_mode = false

    GameData.bomb_unlocked = true
    GameData.block_unlocked = false
    GameData.light_unlocked = false
    GameData.jump_unlocked = true
    GameData.ball_unlocked = false

    game.show_help(
        "Hey, that's a [color=yellow]gun[/color].\n" +
        "Take it, it will be helpful."
    )

    weapon_container.area_entered.connect(func(area):
        if area.is_in_group("PlayerController"):
            _pick_sfx.play()
            weapon_container.queue_free()
            player.enable_weapon = true
            game.show_glitch()

            game.show_help(
                "There you go! Use [color=green]left-click[/color] to shoot!\n" +
                "Destroy this [color=yellow]box[/color] in the way."
            )
    )
