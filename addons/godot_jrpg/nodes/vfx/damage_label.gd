class_name DamageLabel extends Control

const _DAMAGE_COLOR := Color(1.0, 1.0, 1.0, 1.0)
const _HEAL_COLOR := Color(0.4, 1.0, 0.5)

@onready var label: RichTextLabel = $RichTextLabel

func setup(value: int, is_heal: bool) -> void:
	var color := _HEAL_COLOR if is_heal else _DAMAGE_COLOR
	var sign := "+" if is_heal else "-"
	label.text = "[center][b][color=#%s]%s%d[/color][/b][/center]" % [
		color.to_html(false), sign, value
	]
	position -= size / 2.0
	_play_animation()

func _play_animation() -> void:
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 60.0, 1.0) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 0.35).set_delay(0.7)
	tween.finished.connect(queue_free)
