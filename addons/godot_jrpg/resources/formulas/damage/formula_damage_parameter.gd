class_name FormulaDamageParameter extends FormulaParameter

# --- For the damage from battler ---
## The attacker inflicting damage.
var attacker: Battler
## The defender receiving damage. It's also used for the damage from effect.
var defender: Battler

# --- For the damage from effect ---
var effect: Effect
