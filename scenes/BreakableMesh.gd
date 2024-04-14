extends RigidBody3D
class_name GameBreakableMesh

@onready var _mesh := $MeshInstance3D as MeshInstance3D
@onready var _explosion_vfx := $ExplosionVFX as SxGPUParticles3D

const MAX_HEALTH = 5.0

var _health := MAX_HEALTH
var _material: StandardMaterial3D

func _ready() -> void:
    _material = _mesh.material_override as StandardMaterial3D

func _process(delta: float) -> void:
    _material.albedo_color = lerp(Color.WHITE, Color.RED, 1 - _health / MAX_HEALTH)

func hit() -> void:
    _health -= 1

    if _health <= 0:
        _explosion_vfx.spawn_duplicate_at_position(global_position)
        queue_free()