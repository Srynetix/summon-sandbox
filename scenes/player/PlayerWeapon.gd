extends SxFPSWeapon
class_name GamePlayerWeapon

@onready var _flash_vfx := $FlashVFX as SxGPUParticles3D
@onready var _fire_sfx := $FireSFX as SxAudioStreamPlayer
@onready var _impact_sfx := $ImpactSFX as SxAudioStreamPlayer3D
@onready var _weapon_cursor := $WeaponCursor as Node3D

var _mesh_material: StandardMaterial3D
var _erase_mode: bool = false
var _original_albedo: Color

func _ready() -> void:
    super._ready()
    _mesh_material = get_node("WeaponMesh/Cylinder").mesh.surface_get_material(0) as StandardMaterial3D
    _original_albedo = _mesh_material.albedo_color

func _on_fire():
    _fire_sfx.play()
    _flash_vfx.emitting = true

    if raycast.is_colliding():
        var point := raycast.get_collision_point()
        var normal := raycast.get_collision_normal()
        var collider := raycast.get_collider()

        if _erase_mode:
            if collider.is_in_group("Summoned"):
                collider.queue_free()

        else:
            if collider is CSGShape3D:
                _play_impact(point)
                _spawn_decal(collider, point, normal)

            elif collider is RigidBody3D:
                _play_impact(point)
                collider.apply_central_impulse(-normal * 0.5)

            elif collider is StaticBody3D:
                _play_impact(point)
                _spawn_decal(collider, point, normal)

            if collider is GameBreakableMesh:
                collider.hit()

func _on_release():
    _flash_vfx.emitting = false

func _play_impact(point: Vector3) -> void:
    _impact_sfx.spawn_duplicate_at_position(point)

func _process(delta: float) -> void:
    if SxInput.is_action_just_pressed("weapon_next"):
        _erase_mode = !_erase_mode
    elif SxInput.is_action_just_pressed("weapon_previous"):
        _erase_mode = !_erase_mode

    if _erase_mode:
        _mesh_material.albedo_color = Color.GREEN
    else:
        _mesh_material.albedo_color = _original_albedo

    if raycast.is_colliding():
        var point := raycast.get_collision_point()
        var normal := raycast.get_collision_normal()

        _weapon_cursor.visible = true
        _weapon_cursor.global_position = point
        _weapon_cursor.global_transform = SxMath.align_with_normal(_weapon_cursor.global_transform, normal)
        _weapon_cursor.rotation.y = 0
    else:
        _weapon_cursor.visible = false
