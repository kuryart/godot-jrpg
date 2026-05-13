## Abstract class for items and equipments.
@abstract class_name Stuff extends Resource

## The name of the item/equipment.
@export var display_name: String
## The description of the item/equipment.
@export_multiline var description: String
## The icon of the item/equipment.
@export var icon: CompressedTexture2D
## Is this item/equipment a key stuff?
@export var is_key: bool = false
## The price of the item/equipment.
@export var price: int
