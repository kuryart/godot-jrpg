class_name BattleEnemyUI extends BattleBattlerUI

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var engine: BattleEngine
var enemy: Enemy
var shaders = {
	"flash": preload("uid://c5ntiylsybtxo"),
	"damage": preload("uid://clyi8d64f0spx"),
}

func _ready() -> void:
	if not engine.visuals_enabled: return
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	button_up.connect(_on_button_up)
	material = material.duplicate()
	material.set_shader_parameter("flash_percentage", 0.0)

func setup(_enemy: Enemy, _enemy_settings: EnemySettings, _engine: BattleEngine):
	enemy = _enemy
	size = _enemy_settings.size
	position = _enemy_settings.position
	set("texture_normal", _enemy_settings.enemy.sprite)
	engine = _engine

func get_attacked():
	#Audio.play_hit_sound()
	animation_player.stop()
	material.shader = shaders["damage"]
	material.set_shader_parameter("flash_color", Color.RED)
	animation_player.play("damage")
	await animation_player.animation_finished
	await get_tree().create_timer(1.0).timeout
	material.shader = shaders["flash"]
	material.set_shader_parameter("flash_color", Color.WHITE)
	engine.battle_signals.damage_finished.emit()
	
func select_attack():
	var targets: Array[Battler] = [enemy]
	var action = BattleActionAttack.new(engine.current_battler, targets)
	engine.action_pool.append(action)
	engine.battle_signals.enemy_selected.emit()

func _on_focus_entered():
	animation_player.play("flash")

func _on_focus_exited():
	super()
	animation_player.stop()

func _on_button_up():
	if engine.current_phase is BattlePhaseAttack:
		select_attack()
	elif engine.current_phase is BattlePhaseItemTarget:
		#stop_highlight_all()
		#selected_item()
		pass
	elif engine.current_phase is BattlePhaseSkillTarget:
		#selected_skill()
		pass
