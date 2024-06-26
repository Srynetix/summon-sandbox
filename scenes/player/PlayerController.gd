extends SxFPSController
class_name GamePlayerController

signal summoned(items: Array[String], body: Node3D, target: Vector3, normal: Vector3)
signal despawn(body: Node3D)

@onready var summoning_ring := %SummoningRing as GameSummoningRing
@onready var _jump_sfx := $JumpSFX as AudioStreamPlayer
@onready var _dash_sfx := $DashSFX as AudioStreamPlayer

var enable_ring := true

func _ready() -> void:
    super._ready()

    SxCVars.set_cvar("SxFPSControllerJumpSpeed", 12)

    summoning_ring.visible = false
    summoning_ring.selected.connect(func(items):
        summoning_ring.hide_ring()

        var raycast = weapon.raycast
        if !raycast.is_colliding():
            print("Nope")
            return

        var point := raycast.get_collision_point()
        var normal := raycast.get_collision_normal()
        var collider := raycast.get_collider()

        summoned.emit(items, collider, point, normal)
    )

    hitbox.add_to_group("PlayerController")

    weapon.despawn.connect(func(body):
        despawn.emit(body)
    )

func _process(delta: float) -> void:
    super._process(delta)

    if Engine.is_editor_hint():
        return

    if enable_ring && Input.is_action_just_pressed("summon"):
        var raycast = weapon.raycast
        if !raycast.is_colliding():
            print("Nope")
            return

        SxInput.set_input_disabled(true)
        summoning_ring.show_ring()

    elif enable_ring && Input.is_action_just_released("summon"):
        SxInput.set_input_disabled(false)
        summoning_ring.hide_ring()

func _on_hitbox_entered(area: Area3D) -> void:
    if area is GameJumpPlatform:
        _jump_sfx.play()
        var initial_force = area.global_transform.basis.y * 20
        _apply_force_field(initial_force)

func _on_jump() -> void:
    _jump_sfx.play()

func _on_dash() -> void:
    _dash_sfx.play()