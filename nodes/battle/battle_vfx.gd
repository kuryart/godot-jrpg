class_name BattleVFX extends Node

var engine: BattleEngine

func setup(_engine: BattleEngine):
	engine = _engine
	engine.battle_signals.player_damaged.connect(_on_player_damaged)
	engine.battle_signals.enemy_damaged.connect(_on_enemy_damaged)

func _on_enemy_damaged(target: BattleEnemyUI):
	if not target.is_alive(): return
	var hit_vfx = VFXManager.vfx_bank_battle.bank["hit"]
	play_vfx_at_battler(hit_vfx, target)

func _on_player_damaged(face: BattleFace):
	if not face.is_alive(): return
	var hit_vfx = VFXManager.vfx_bank_battle.bank["hit"]
	play_vfx_at_battler(hit_vfx, face)
	
func play_vfx_at_battler(vfx: VFX, battler: Control):
	var screen_pos = battler.global_position + (battler.size / 2)
	VFXManager.play_at_screen_position(vfx, screen_pos, 10.0)
