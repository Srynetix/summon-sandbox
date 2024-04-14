@tool
extends Area3D
class_name GameRemovableZone

@export var shape_size: Vector3 = Vector3.ONE : set = _set_shape_size
@export var csg_shape: CSGShape3D
@export var repeat: bool = false : set = _set_repeat
@export var texture: Texture2D: set = _set_texture

@onready var _collision_shape := $CollisionShape3D as CollisionShape3D
@onready var _shape = _collision_shape.shape as BoxShape3D
@onready var _decal := $SxDecal as SxDecal

func _set_shape_size(value: Vector3) -> void:
    shape_size = value

    if _shape == null:
        await self.ready

    _decal.width = value.x
    _decal.height = value.z
    _shape.size = value

func _set_repeat(value: bool) -> void:
    repeat = value

    if _decal == null:
        await self.ready

    _decal.repeat = repeat

func _set_texture(value: Texture2D) -> void:
    texture = value

    if _decal == null:
        await self.ready

    _decal.texture = texture

func _ready() -> void:
    _set_shape_size(shape_size)
    _set_repeat(repeat)