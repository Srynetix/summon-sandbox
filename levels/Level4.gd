extends GameLevel

@onready var _weapon_mesh := %Weapon as Node3D
@onready var _weapon_erase_wrapper := %WeaponEraseWrapper as Area3D
@onready var _pick_sfx := $PickSFX as AudioStreamPlayer

const _material := preload("res://resources/WeaponMainSurfaceGreen.tres")

func _ready() -> void:
    super._ready()

    var mesh := _weapon_mesh.get_node("Cylinder") as MeshInstance3D
    mesh.set_surface_override_material(0, _material)

    player.weapon.enable_erase_mode = false
    GameData.jump_unlocked = true
    GameData.bomb_unlocked = true
    GameData.block_unlocked = true
    GameData.ball_unlocked = true

    game.show_help(
        "Hmmm... That's another [color=yellow]gun[/color].\n" +
        "Oh! It's not really a gun, take it, it will be useful later."
    )

    _weapon_erase_wrapper.area_entered.connect(func(area):
        if area.is_in_group("PlayerController"):
            _pick_sfx.play()
            _weapon_erase_wrapper.queue_free()
            player.weapon.enable_erase_mode = true
            game.show_glitch()

            game.show_help(
                "Okay! You can now [color=yellow]remove[/color] things you summoned!\n" +
                "To do this, change your gun using your [color=yellow]mouse scroll wheel[/color]."
            )
    )
