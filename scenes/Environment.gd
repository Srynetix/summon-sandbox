@tool
extends Node3D
class_name GameEnvironment

@export var environment: Environment
@onready var _environment: WorldEnvironment = $WorldEnvironment as WorldEnvironment

func _ready() -> void:
    _set_environment(environment)

func _set_environment(value: Environment) -> void:
    environment = value
    if _environment == null:
        await self.ready

    _environment.environment = environment