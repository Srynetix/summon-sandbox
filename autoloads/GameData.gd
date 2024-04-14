extends SxGameData

var current_level_idx := 1

var bomb_unlocked := false
var jump_unlocked := false
var light_unlocked := false
var block_unlocked := false
var ball_unlocked := false

var bomb_used := false
var jump_used := false
var light_used := false
var block_used := false
var ball_used := false

func _init() -> void:
    default_file_path = "user://ld55-save.dat"