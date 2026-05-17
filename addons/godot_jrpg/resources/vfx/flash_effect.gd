class_name FlashEffect extends Resource

## Color applied to the full-screen ColorRect.
@export var color: Color = Color.WHITE
## Animation played on VFXManager's AnimationPlayer.
## Must animate ScreenFlashRect:modulate:a on VFXManager's root.
@export var animation: Animation
