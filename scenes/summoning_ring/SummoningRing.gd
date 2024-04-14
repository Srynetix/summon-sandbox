extends Control
class_name GameSummoningRing

# Help
#
# Star: 
# Heart: 
# Moon: 
# Square: 
# Circle: 
# Meteor: 

var ring_count := 4

const KNOWN_ICONS = ["star", "circle", "heart", "moon", "square", "meteor"]
const ITEMS_PER_RING := len(KNOWN_ICONS)
const ANGLE_OFFSET := (PI * 2.0) / ITEMS_PER_RING
const HEIGHT := 400.0
const PADDING := 10.0

@onready var _select_sfx := $SelectSFX as AudioStreamPlayer
@onready var _cursor_sfx := $CursorSFX as AudioStreamPlayer
@onready var _ring_ko_sfx := $RingKoSFX as AudioStreamPlayer
@onready var _ring_ok_sfx := $RingOkSFX as AudioStreamPlayer
@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var _caption := %Caption as RichTextLabel

var _selected_items: Array[String] = []
var _current_ring_idx := 0
var _current_selected_idx := 0

var show_bomb_caption: bool = true
var show_jump_platform_caption: bool = true
var show_light_caption: bool = true
var show_block_caption: bool = true

signal selected(items: Array[String])

func play_ok_sfx() -> void:
    _ring_ok_sfx.play()

func play_ko_sfx() -> void:
    _ring_ko_sfx.play()

func show_ring() -> void:
    animation_player.play("show")
    _selected_items = []
    _current_ring_idx = 0
    _current_selected_idx = 0
    _cursor_sfx.play()

func hide_ring():
    animation_player.play("hide")

func _ready():
    var radius: float = HEIGHT / 2.0 - PADDING
    var ring_size_offset := (radius / ring_count as float)

    for ring_idx in range(ring_count):
        if ring_idx == ring_count - 1:
            continue

        var ring_size := radius - (ring_size_offset * ring_idx)
        for item_idx in range(ITEMS_PER_RING):
            var local_angle_offset = ANGLE_OFFSET * item_idx
            var label := SxFaLabel.new()
            label.icon_name = KNOWN_ICONS[item_idx]
            label.icon_size = 36 - (ring_count * 1.75 * ring_idx) as int
            label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
            label.position.x = cos(local_angle_offset) * (ring_size - ring_size_offset / 2.0) - label.icon_size / 2.0
            label.position.y = sin(local_angle_offset) * (ring_size - ring_size_offset / 2.0) - label.icon_size / 2.0
            add_child(label)

func _get_item_idx_at_mouse() -> int:
    return _current_selected_idx

func _process(delta: float) -> void:
    if visible:
        if Input.is_action_just_pressed("fire"):
            if _current_ring_idx < ring_count - 1:
                _current_ring_idx += 1
                _selected_items.append(KNOWN_ICONS[_get_item_idx_at_mouse()])

                if _current_ring_idx == ring_count - 1:
                    selected.emit(_selected_items)
                else:
                    _select_sfx.play()

        if Input.is_action_just_pressed("summon_next"):
            _current_selected_idx = wrap(_current_selected_idx - 1, 0, len(KNOWN_ICONS))
            _cursor_sfx.play()

        elif Input.is_action_just_pressed("summon_previous"):
            _current_selected_idx = wrap(_current_selected_idx + 1, 0, len(KNOWN_ICONS))
            _cursor_sfx.play()

        queue_redraw()

        var text = ""

        # Setup caption
        if GameData.bomb_used:
            text += "bomb = star + meteor + square\n"
        if GameData.jump_used:
            text += "arrows-up-to-line = heart + moon + star\n"
        if GameData.light_used:
            text += "lightbulb = meteor + star + circle\n"
        if GameData.block_used:
            text += "square = square + square + square\n"
        if GameData.ball_used:
            text += "circle = circle + circle + circle\n"

        _caption.text = text

func _draw() -> void:
    var radius = HEIGHT / 2.0 - PADDING
    var ring_size_offset := (radius / ring_count as float)

    var color = SxColor.with_alpha_f(Color.BLACK, 0.5)
    for ring_idx in range(ring_count):
        var ring_padding = (radius / ring_count) * ring_idx
        draw_circle(get_viewport_rect().size / 2, radius - ring_padding, color)

    if Engine.is_editor_hint():
        return

    if _current_ring_idx == ring_count - 1:
        # Do not show mouse if finished
        return

    var item_idx = _get_item_idx_at_mouse()
    var mouse_angle = item_idx * ANGLE_OFFSET;
    var length = radius - (ring_size_offset / 2) - (_current_ring_idx * ring_size_offset)

    draw_circle(get_viewport_rect().size / 2 + Vector2(length, 0).rotated(mouse_angle), 32, SxColor.with_alpha_f(Color.GREEN, 0.5))
