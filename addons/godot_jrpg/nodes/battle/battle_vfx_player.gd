class_name BattleVFXPlayer extends Node

@export var battle_signals: BattleSignals
@export var damage_label_scene: PackedScene

func _ready() -> void:
	battle_signals.engine_initialized.connect(_on_engine_initialized, CONNECT_ONE_SHOT)

func _on_engine_initialized(_engine: BattleEngine) -> void:
	battle_signals.player_damaged.connect(_on_player_damaged)
	battle_signals.enemy_damaged.connect(_on_enemy_damaged)
	battle_signals.battler_value_displayed.connect(_on_battler_value_displayed)
	battle_signals.vfx_play_at_position.connect(_on_vfx_play_at_position)

func _on_enemy_damaged(target: BattleEnemyUI) -> void:
	var vfx: VFX = VFXManager.vfx_bank_battle.bank["hit"]
	VFXManager.play_at_screen_position(vfx, target.get_global_rect().get_center(), 10.0)
	if vfx.target_flash:
		target.play_target_flash(vfx.target_flash)
	if vfx.screen_flash:
		VFXManager.play_screen_flash(vfx.screen_flash)

func _on_player_damaged(face: BattleFace) -> void:
	var vfx: VFX = VFXManager.vfx_bank_battle.bank["hit"]
	VFXManager.play_at_screen_position(vfx, face.get_global_rect().get_center(), 10.0)
	if vfx.target_flash:
		face.play_target_flash(vfx.target_flash)
	if vfx.screen_flash:
		VFXManager.play_screen_flash(vfx.screen_flash)

func _on_battler_value_displayed(position: Vector2, value: int, is_heal: bool) -> void:
	if not damage_label_scene:
		return
	var label := damage_label_scene.instantiate() as DamageLabel
	VFXManager.add_child(label)
	label.global_position = position
	label.setup(value, is_heal)

func _on_vfx_play_at_position(vfx: VFX, position: Vector2) -> void:
	VFXManager.play_at_screen_position(vfx, position, 10.0)
	if vfx.screen_flash:
		VFXManager.play_screen_flash(vfx.screen_flash)
