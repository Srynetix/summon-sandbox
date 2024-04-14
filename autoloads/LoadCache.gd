extends SxLoadCache

func load_resources() -> void:
    store_scene("TitleScreen", "res://screens/TitleScreen.tscn")
    store_scene("GameScreen", "res://screens/GameScreen.tscn")
    store_scene("EndScreen", "res://screens/EndScreen.tscn")

    store_scene("Level1", "res://levels/Level1.tscn")
    store_scene("Level2", "res://levels/Level2.tscn")
    store_scene("Level3", "res://levels/Level3.tscn")
    store_scene("Level4", "res://levels/Level4.tscn")
    store_scene("Level5", "res://levels/Level5.tscn")

    store_scene("JumpPlatform", "res://scenes/jump_platform/JumpPlatform.tscn")
    store_scene("BreakableMesh", "res://scenes/BreakableMesh.tscn")
    store_scene("Ball", "res://scenes/Ball.tscn")