class_name BattleVFXPlayer extends Node

@export var battle_signals: BattleSignals

func _ready() -> void:
	battle_signals.engine_initialized.connect(_on_engine_initialized, CONNECT_ONE_SHOT)

func _on_engine_initialized(_engine: BattleEngine) -> void:
	battle_signals.player_damaged.connect(_on_player_damaged)
	battle_signals.enemy_damaged.connect(_on_enemy_damaged)

func _on_enemy_damaged(target: BattleEnemyUI) -> void:
	play_vfx_at_battler(VFXManager.vfx_bank_battle.bank["hit"], target)

func _on_player_damaged(face: BattleFace) -> void:
	play_vfx_at_battler(VFXManager.vfx_bank_battle.bank["hit"], face)

func play_vfx_at_battler(vfx: VFX, battler: Control) -> void:
	VFXManager.play_at_screen_position(vfx, battler.get_global_rect().get_center(), 10.0)
