## This class represents a status, like burning, poisoned, stunned, etc.
@tool
class_name Status extends Resource

## The status name.
@export var name: String
## When the status effects are resolved.
@export_enum("Nothing",
	"Upkeep", 
	"Clean Up", 
	"Pre-Action", 
	"Post-Action") var resolve_in: String = "Upkeep"
## Does this status restricts target actions?
@export_enum("Nothing", 
	"Can't act", 
	"Attack Foe", 
	"Attack Ally", 
	"Attack Both") var action_restriction: String = "Nothing"
## The traits attached to this status.
@export var traits: TraitList
## The dead state is a special one. It restricts all actions, and don't go away with
## turns, damage or steps. You can set a different name for the state in the editor.
## You can also create a new state with this flag on, and create something like
## "Dead" by default, "Terminated" for a player and "Obliterated" for and enemy.
## You can also set the default execution status in the battler, i.e., which state
## will be used as the target's dead state. The resolution order is:
## [br][br]
## 1. Attacker execution status; [br]
## 2. Defender executed status; [br]
## 3. Default dead status;
## [br][br]
## The system automatically uses the pre-created state called "dead.tres" as the 
## default resource, and it is used when a battler dies.
@export var is_dead_state: bool = false

@export_group("End Conditions")
## When the status ends. If you select something else than "Nothing", you will be 
## able to define [member duration_min], [member duration_max] and 
## [member chance_to_end].
@export_enum("Nothing",
	"Upkeep", 
	"Clean Up", 
	"Pre-Action", 
	"Post-Action") var end_in: String = "Clean Up":
	set(v):
		end_in = v
		notify_property_list_changed()
## The minimum number of turns to ends the status. Example:
## A value of 2 means the [i]status end check[/i] must starts in turn 2.
@export_range(1, 1000, 1) var duration_min: int = 1
## The maximum number of turns to ends the status. Example:
## a value of 3 means the status must end until turn 3.
@export_range(1, 1000, 1)  var duration_max: int = 1
## The chance to end the status in the period defined by [member duration_min] and [member
## duration_max].
@export var chance_to_end: float = 0.5
## If the status is ended by a percentage of damage received by battler.
@export var is_ended_by_damage: bool = false:
	set(v):
		is_ended_by_damage = v
		notify_property_list_changed()
## The percentage of damage the battler must receive to end the status.
@export_range(0.0, 100.0, 0.1) var damage_percentage: float = 0.0
## If the status is ended by the number of steps in the map.
@export var is_ended_by_steps: bool = false:
	set(v):
		is_ended_by_steps = v
		notify_property_list_changed()
## The number of steps to dissipate status.
@export_range(0, 1000000, 1) var steps: int = 0

@export_group("Messages")
# The message when ally is affected.
@export var message_ally_affected: String
# The message when enemy is affected.
@export var message_enemy_affected: String
# The message when the effect continues to affect the ally.
@export var message_continuous_effect_ally: String
# The message when the effect continues to affect the enemy.
@export var message_continuous_effect_enemy: String
## The message when the status dissipates on ally.
@export var message_restore_ally: String
## The message when the status dissipitates on enemy.
@export var message_restore_enemy: String

## The icon for the status
@export var icon: Texture

## The tick to count the effect duration.
var tick: int = 0

func process_duration() -> bool:
	tick += 1
	return tick >= duration_max

## Used to show and hide things in the editor.
func _validate_property(property: Dictionary):
	if property.name in ["duration_min", "duration_max", "chance_to_end"]:
		if end_in == "Nothing":
			property.usage = PROPERTY_USAGE_NO_EDITOR
		
	if property.name == "damage_percentage":
		if not is_ended_by_damage:
			property.usage = PROPERTY_USAGE_NO_EDITOR
	
	if property.name == "steps":
		if not is_ended_by_steps:
			property.usage = PROPERTY_USAGE_NO_EDITOR
