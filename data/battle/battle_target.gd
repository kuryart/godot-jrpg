class_name BattleTarget extends Resource

enum Scope { ONE, ALL }
enum Side { ENEMIES, ALLIES, BOTH, SELF }

@export var scope: BattleTarget.Scope = Scope.ONE
@export var side: BattleTarget.Side = Side.ENEMIES
@export var include_dead: bool = false
