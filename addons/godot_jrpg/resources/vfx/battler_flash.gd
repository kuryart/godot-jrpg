class_name BattlerFlash extends Resource

## Color applied to the battler's shader flash_color parameter.
@export var color: Color = Color.WHITE
## Animation played on the battler's AnimationPlayer.
## Must animate shader_parameter/flash_percentage on the root node.
@export var animation: Animation
