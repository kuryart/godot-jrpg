## Class that describes info for an enemy. It's like an enemy character sheet.
class_name Enemy extends Battler

## The enemy sprite displayed in the battle. It's size can be defined in [EnemySettings].
@export var sprite: Texture2D
@export var loot: Array[Loot]
@export var money: int
@export var xp: int
