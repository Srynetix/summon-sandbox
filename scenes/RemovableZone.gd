@tool
extends Area3D
class_name GameRemovableZone

@export var shape_size: Vector3 = Vector3.ONE : set = _set_shape_size
@export var csg_shape: CSGShape3D

@onready var _collision_shape := $CollisionShape3D as CollisionShape3D
@onready var _shape = _collision_shape.shape as BoxShape3D

func _set_shape_size(value: Vector3) -> void:
    shape_size = value

    if _shape == null:
        await self.ready

    _shape.size = value

func _ready() -> void:
    _set_shape_size(shape_size)