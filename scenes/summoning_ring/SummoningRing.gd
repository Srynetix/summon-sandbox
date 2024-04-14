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

@onready var animation_player := $AnimationPlayer as AnimationPlayer

var _selected_items: Array[String] = []
var _current_ring_idx := 0
var _current_selected_idx := 0

signal selected(items: Array[String])

func show_ring() -> void:
    animation_player.play("show")
    _selected_items = []
    _current_ring_idx = 0

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
            label.icon_size = 32 - (ring_count * 1.25 * ring_idx) as int
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

        if Input.is_action_just_pressed("summon_next"):
            _current_selected_idx = wrap(_current_selected_idx - 1, 0, len(KNOWN_ICONS))

        elif Input.is_action_just_pressed("summon_previous"):
            _current_selected_idx = wrap(_current_selected_idx + 1, 0, len(KNOWN_ICONS))

        queue_redraw()

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