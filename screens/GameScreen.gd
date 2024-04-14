extends Node3D
class_name GameGameScreen

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
    Light,
    Nothing
}

var level: GameLevel

func show_glitch() -> void:
    _glitch_fx.visible = true
    var tween := get_tree().create_tween()
    tween.tween_property(_glitch_fx, "amount", 5, 0.25).from(0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
    await tween.finished

    tween = get_tree().create_tween()
    tween.tween_property(_glitch_fx, "amount", 0, 0.25)
    await tween.finished
    _glitch_fx.visible = false

func _ready() -> void:
    if Engine.is_editor_hint():
        return

    if !GameMusic.playing:
        GameMusic.play()

    _glitch_fx.visible = false
    _dissolve.visible = false

    SxDebugTools.get_global_instance(get_tree())
    _player.summoned.connect(_spawn)
    _player.despawn.connect(_despawn)

    # Spawn level
    var level_scene: PackedScene
    if GameData.current_level_idx == 1:
        level_scene = LoadCache.load_scene("Level1")
    elif GameData.current_level_idx == 2:
        level_scene = LoadCache.load_scene("Level2")
    elif GameData.current_level_idx == 3:
        level_scene = LoadCache.load_scene("Level3")
    elif GameData.current_level_idx == 4:
        level_scene = LoadCache.load_scene("Level4")
    else:
        level_scene = LoadCache.load_scene("Level5")

    level = level_scene.instantiate() as GameLevel

    # Remove environment if present
    if level.has_node("Environment"):
        level.get_node("Environment").queue_free()

    level.player = _player
    level.game = self
    add_child(level)

    _player.global_position = level.get_node("PlayerPosition").global_position
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
            if GameData.current_level_idx == 6:
                GameSceneTransitioner.fade_to_cached_scene(LoadCache, "EndScreen")
            else:
                GameSceneTransitioner.fade_to_cached_scene(LoadCache, "GameScreen")
    )

func _items_to_scene(items: Array[String], body: Node3D) -> Item:
    if GameData.jump_unlocked && items[0] == "heart" and items[1] == "moon" and items[2] == "star":
        GameData.jump_used = true
        return Item.JumpPlatform

    if GameData.bomb_unlocked && items[0] == "star" and items[1] == "meteor" and items[2] == "square":
        if body is GameRemovableZone:
            GameData.bomb_used = true
            return Item.Hole

    if GameData.block_unlocked && items[0] == "square" and items[1] == "square" and items[2] == "square":
        GameData.block_used = true
        return Item.BreakableCube

    if GameData.ball_unlocked && items[0] == "circle" and items[1] == "circle" and items[2] == "circle":
        GameData.ball_used = true
        return Item.Ball

    if GameData.light_unlocked && items[0] == "meteor" and items[1] == "star" and items[2] == "circle":
        GameData.light_used = true
        return Item.Light

    return Item.Nothing

func _spawn(items: Array[String], body: Node3D, target: Vector3, normal: Vector3) -> void:
    var item := _items_to_scene(items, body)
    if item == Item.Nothing:
        _player.summoning_ring.play_ko_sfx()
        return

    _player.summoning_ring.play_ok_sfx()

    if item == Item.Light:
        level.toggle_lights()
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
        node = LoadCache.load_scene("JumpPlatform").instantiate()
        node.add_to_group("Summoned")
        add_child(node)
    elif item == Item.BreakableCube:
        node = LoadCache.load_scene("BreakableMesh").instantiate()
        node.add_to_group("Summoned")
        add_child(node)
    elif item == Item.Ball:
        node = LoadCache.load_scene("Ball").instantiate()
        node.add_to_group("Summoned")
        add_child(node)

    node.global_position = target
    node.global_transform = SxMath.align_with_normal(node.global_transform, normal)

    _spawn_vfx.spawn_duplicate_at_position(target, true)

func _despawn(body: Node3D) -> void:
    _spawn_vfx.spawn_duplicate_at_position(body.global_position, true)
    body.queue_free()

func show_help(text: String) -> void:
    _help.update_text(text)
    _help.fade_in()
    await _help.shown

func _unhandled_input(event: InputEvent):
    if event is InputEventMouseButton:
        if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

    elif event is InputEventKey:
        if event.pressed && event.physical_keycode == KEY_ESCAPE:
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE