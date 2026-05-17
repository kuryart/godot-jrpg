class_name Target extends Resource

enum Scope { ONE, ALL }
enum Side { ENEMIES, ALLIES, BOTH, SELF, EVERYONE }

@export var scope: Target.Scope = Scope.ONE
@export var side: Target.Side = Side.ENEMIES
@export var include_dead: bool = false

# --- Check sides ---
static func is_target_side_enemies(side: Target.Side):
	return side == Target.Side.ENEMIES

static func is_target_side_allies(side: Target.Side):
	return side == Target.Side.ALLIES

static func is_target_side_both(side: Target.Side):
	return side == Target.Side.BOTH

static func is_target_side_self(side: Target.Side):
	return side == Target.Side.SELF

static func is_target_side_everyone(side: Target.Side):
	return side == Target.Side.EVERYONE

# --- Check scopes ---
static func is_target_scope_one(scope: Target.Scope):
	return scope == Target.Scope.ONE

static func is_target_scope_all(scope: Target.Scope):
	return scope == Target.Scope.ALL
