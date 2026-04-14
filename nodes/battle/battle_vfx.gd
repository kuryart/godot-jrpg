class_name BattleVFX extends Node

var engine: BattleEngine
var container: SubViewportContainer

func setup(_engine: BattleEngine, _container: SubViewportContainer):
	engine = _engine
	container = _container

func _on_damaged(target: Battler):
	if not target.is_alive(): return
	play_vfx_at_battler(target)

func _on_face_damaged(face: BattleFace):
	play_vfx_at_player(face)

func play_vfx_at_enemy(enemy: Enemy):
	var enemy_ui = engine.battle_ui.enemies[enemy]
	var screen_pos = enemy_ui.global_position + (enemy_ui.size / 2)
	VFXManager.play_at_screen_position("hit", VFXManager.vfx_bank_battle, screen_pos, 10.0)

func play_vfx_at_player(face: BattleFace):
	var screen_pos = face.global_position + (face.size / 2)
	VFXManager.play_at_screen_position("hit", VFXManager.vfx_bank_battle, screen_pos, 10.0)
	
func play_vfx_at_battler(battler: Battler):
	if battler is Enemy:
		play_vfx_at_enemy(battler)
	else:
		play_vfx_at_player(engine.battle_ui.face)
