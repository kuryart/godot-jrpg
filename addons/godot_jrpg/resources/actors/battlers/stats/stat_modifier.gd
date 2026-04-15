class_name StatModifier extends Resource

enum Type { ADDITIVE, MULTIPLICATIVE }

@export var name: String = "Modifier"
@export var value: float = 0.0
@export var type: Type = Type.MULTIPLICATIVE

# Útil para o Jupyter saber de onde veio esse valor
@export var source: String = ""
