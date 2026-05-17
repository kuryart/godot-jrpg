class_name BattleInputSkills extends BattleInput

func resolve(engine: BattleEngine):
	engine.current_phase.end()
	await engine.change_phase(BattlePhaseSkillSelect.new())
