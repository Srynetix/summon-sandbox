extends Node3D
class_name GameGameScreen

const JUMP_PLATFORM := preload("res://scenes/jump_platform/JumpPlatform.tscn")
const CUBE := preload("res://scenes/Cube.tscn")
const BALL := preload("res://scenes/Ball.tscn")
const BREAKABLE_CUBE := preload("res://scenes/BreakableMesh.tscn")

const LEVEL1 := preload("res://levels/Level1.tscn")
const LEVEL2 := preload("res://levels/Level2.tscn")

@onready var _player := %PlayerController as GamePlayerController
@onready var _spawn_vfx := $SpawnVFX as SxGPUParticles3D
@onready var _ground_zone := $GroundZone as Area3D
@onready var _glitch_fx := %GlitchFX as SxFxChromaticAberration
@onready var _dissolve := %DissolveFX as SxFxDissolve
@onready var _animation_player := %AnimationPlayer as AnimationPlayer
@onready var _help := %Help as SxFadingRichTextLabel

enum Item {
    JumpPlatform,
    Cube,
    Ball,
    Hole,
    BreakableCube,
    Nothing
}

func show_glitch() -> void:
    var tween := get_tree().create_tween()
    tween.tween_property(_glitch_fx, "amount", 10, 0.25).from(0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
    await tween.finished

    tween = get_tree().create_tween()
    tween.tween_property(_glitch_fx, "amount", 0, 0.25)
    await tween.finished

func _ready() -> void:
    _dissolve.visible = false

    SxDebugTools.get_global_instance(get_tree())
    _player.summoned.connect(_spawn)

    # Spawn level
    var level_scene: PackedScene
    if GameData.current_level_idx == 1:
        level_scene = LEVEL1
    else:
        level_scene = LEVEL2

    var level = level_scene.instantiate() as GameLevel

    level.player = _player
    level.game = self
    add_child(level)
    _player.global_position = level.get_node("PlayerPosition").global_position

    await GameSceneTransitioner.fade_in()

    _ground_zone.area_entered.connect(func(area):
        if area.is_in_group("PlayerController"):
            _player.enable_movement = false
            _player.enable_ring = false

            _dissolve.visible = true
            await get_tree().process_frame
            var tween := get_tree().create_tween()
            tween.tween_property(_dissolve, "ratio", 1.0, 0.5).from(0.0)

            _animation_player.play("success")
            await _animation_player.animation_finished

            GameData.current_level_idx += 1
            GameSceneTransitioner.fade_to_scene_path("res://screens/GameScreen.tscn")
    )

func _items_to_scene(items: Array[String], body: Node3D) -> Item:
    if items[0] == "heart" and items[1] == "moon" and items[2] == "star":
        return Item.JumpPlatform

    if items[0] == "star" and items[1] == "meteor" and items[2] == "square":
        if body is GameRemovableZone:
            return Item.Hole

    if items[0] == "square" and items[1] == "square" and items[2] == "square":
        return Item.BreakableCube

    return Item.Nothing

func _spawn(items: Array[String], body: Node3D, target: Vector3, normal: Vector3) -> void:
    var item := _items_to_scene(items, body)
    if item == Item.Nothing:
        return

    var node: Node3D
    if item == Item.Hole:
        var box := CSGBox3D.new()
        box.operation = CSGShape3D.OPERATION_SUBTRACTION
        box.size.x = 3
        box.size.y = 3
        box.size.z = 3
        node = box
        body.csg_shape.add_child(node)
        show_glitch()
    elif item == Item.JumpPlatform:
        node = JUMP_PLATFORM.instantiate()
        node.add_to_group("Summoned")
        add_child(node)
    elif item == Item.Cube:
        node = CUBE.instantiate()
        node.add_to_group("Summoned")
        add_child(node)
    elif item == Item.BreakableCube:
        node = BREAKABLE_CUBE.instantiate()
        node.add_to_group("Summoned")
        add_child(node)
    elif item == Item.Ball:
        node = BALL.instantiate()
        node.add_to_group("Summoned")
        add_child(node)

    node.global_position = target
    node.global_transform = SxMath.align_with_normal(node.global_transform, normal)

    _spawn_vfx.spawn_duplicate_at_position(target, true)

func show_help(text: String) -> void:
    _help.update_text(text)
    _help.fade_in()
