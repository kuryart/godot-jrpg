class_name Target extends Resource

enum Scope { ONE, ALL }
enum Side { ENEMIES, ALLIES, BOTH, SELF }

@export var scope: Target.Scope = Scope.ONE
@export var side: Target.Side = Side.ENEMIES
@export var include_dead: bool = false
