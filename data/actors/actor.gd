## Generic class that describes info for an actor. It's like an actor character sheet.
## An actor is any character in the game: players, enemies and NPCs. 
## An actor can be a [Battler], which fights battles.
class_name Actor extends Resource

## The actor's name, used by players and enemies.
@export var name: String
## The actor's description, used by players and enemies.
@export_multiline var description: String
