## Class for the team's party.
class_name Party extends Resource

## The players who are in the team's party.
@export var players: Array[Player]
## The team's inventory.
@export var inventory: Inventory
## The team's money.
@export var money: int

## Adds money to the team.
func add_money(amount: int):
	money += amount

## Removes money from the team.
func remove_money(amount: int):
	money -= amount
