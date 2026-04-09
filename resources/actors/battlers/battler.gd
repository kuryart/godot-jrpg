## Generic class that describes data, like stats and controller, for a battler. 
## It's like a battler character sheet.
class_name Battler extends Actor

## The battler stats.
@export var stats: Stats
## The battler current status.
@export var status: Array[Status]
## The controller used by battler. It can be Manual, NPC, Simulation, or RL (Reinforcement Learning). Learn more in [BattlerController].
@export var controller: BattlerController

## Checks if battler is alive.
func is_alive(hp: int) -> bool:
	return hp > 0 and not status.any(func(s): return s is StatusDead)
