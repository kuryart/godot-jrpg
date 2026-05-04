## This is the class for the equipment menu
##
## The sequence executed in [method _ready] is:
## [br]
## [br]1. First we register the menu in the menus stack (see MenuManager autoload for more info);
## [br]2. Then we connect signals from equipment buttons;
## [br]3. We hide the equipments lists in the inventory, because we want to be shown only the one
## respective to the button which have focus at the moment. E.g.: if the button which have
## focus at the moment is the weapon button, so we show the weapon list;
## [br]4. We populate the buttons that represents the equipped equipments (slots);
## [br]5. We populate the buttons that represents the equipments to be equipped, i.e,
## the equipments in inventory.
## [br]6. Finally we give focus to the fisrt button.
class_name MenuEquip extends Control

# --- Equipped buttons ---
## The button that represents the equipped weapon.
@onready var weapon_equipped_button: WeaponEquippedButton = %WeaponEquippedButton
## The button that represents the equipped armor.
@onready var armor_equipped_button: ArmorEquippedButton = %ArmorEquippedButton
## The button that represents the equipped accessory.
@onready var accessory_equipped_button: AccessoryEquippedButton = %AccessoryEquippedButton
## The button that represents the equipped head.
@onready var head_equipped_button: HeadEquippedButton = %HeadEquippedButton
## The button that represents the equipped shield.
@onready var shield_equipped_button: ShieldEquippedButton = %ShieldEquippedButton

# --- Equipped names ---
## The label that represents the equipped weapon name.
@onready var weapon_equipped_name: Label = %WeaponEquippedName
## The label that represents the equipped armor name.
@onready var armor_equipped_name: Label = %ArmorEquippedName
## The label that represents the equipped accessory name.
@onready var accessory_equipped_name: Label = %AccessoryEquippedName
## The label that represents the equipped head name.
@onready var head_equipped_name: Label = %HeadEquippedName
## The label that represents the equipped shield name.
@onready var shield_equipped_name: Label = %ShieldEquippedName

# --- Equipped icons ---
## The texture rect that represents the equipped weapon icon.
@onready var weapon_equipped_icon: TextureRect = %WeaponEquippedIcon
## The texture rect that represents the equipped armor icon.
@onready var armor_equipped_icon: TextureRect = %ArmorEquippedIcon
## The texture rect that represents the equipped accessory icon.
@onready var accessory_equipped_icon: TextureRect = %AccessoryEquippedIcon
## The texture rect that represents the equipped head icon.
@onready var head_equipped_icon: TextureRect = %HeadEquippedIcon
## The texture rect that represents the equipped shield icon.
@onready var shield_equipped_icon: TextureRect = %ShieldEquippedIcon

# --- Equip scrolls ---
## The scroll container that represents the parent of the list of weapons in the inventory.
## This will be hide and shown as the player changes the cursor.
@onready var weapon_equip_scroll: ScrollContainer = %WeaponEquipScroll
## The scroll container that represents the parent of the list of armors in the inventory.
## This will be hide and shown as the player changes the cursor.
@onready var armor_equip_scroll: ScrollContainer = %ArmorEquipScroll
## The scroll container that represents the parent of the list of accessories in the inventory.
## This will be hide and shown as the player changes the cursor.
@onready var accessory_equip_scroll: ScrollContainer = %AccessoryEquipScroll
## The scroll container that represents the parent of the list of head in the inventory.
## This will be hide and shown as the player changes the cursor.
@onready var head_equip_scroll: ScrollContainer = %HeadEquipScroll
## The scroll container that represents the parent of the list of shield in the inventory.
## This will be hide and shown as the player changes the cursor.
@onready var shield_equip_scroll: ScrollContainer = %ShieldEquipScroll

# --- Equip VBoxes ---
## The VBox container that represents the list of weapons in the inventory.
@onready var weapon_equip_v_box: VBoxContainer = %WeaponEquipVBox
## The VBox container that represents the list of armors in the inventory.
@onready var armor_equip_v_box: VBoxContainer = %ArmorEquipVBox
## The VBox container that represents the list of accessories in the inventory.
@onready var accessory_equip_v_box: VBoxContainer = %AccessoryEquipVBox
## The VBox container that represents the list of heads in the inventory.
@onready var head_equip_v_box: VBoxContainer = %HeadEquipVBox
## The VBox container that represents the list of shields in the inventory.
@onready var shield_equip_v_box: VBoxContainer = %ShieldEquipVBox

# --- Messenger ---
## The label which shows the equipments descriptions.
@onready var messenger_label: RichTextLabel = %MessengerLabel

## The signals for the menus. See more at [MenuSignals]
@export var menu_signals: MenuSignals
## We need to know which player is the one that equipment is being changed for.
@export var player: Player

# --- Equip buttons ---
@export_group("Buttons")
## The packed scene for the button that represents the weapon to be equipped, i.e., the
## weapon in the inventory.
@export var weapon_equip_container: PackedScene
## The packed scene for the button that represents the armor to be equipped, i.e., the
## armor in the inventory.
@export var armor_equip_container: PackedScene
## The packed scene for the button that represents the accessory to be equipped, i.e., the
## accessory in the inventory.
@export var accessory_equip_container: PackedScene
## The packed scene for the button that represents the head to be equipped, i.e., the
## head in the inventory.
@export var head_equip_container: PackedScene
## The packed scene for the button that represents the shield to be equipped, i.e., the
## shield in the inventory.
@export var shield_equip_container: PackedScene

## This state machine controls the phase of the equip menu.
enum States { 
		SLOT_SELECTION, ## the moment when we select the equipped items to be switched.
		ITEM_SELECTION ## the moment when we select the item in the inventory to switch by.
	}
## The current state of equip menu.
var current_state = States.SLOT_SELECTION

## The last focused slot, to know to where to get back from item selection phase. See [enum States].
var last_focused_slot: Control

func _ready() -> void:
	MenuManager.register_menu(self)
	connect_signals()
	hide_scrolls()
	populate_equipped_buttons()
	populate_equip_buttons()
	weapon_equipped_button.grab_focus()

func _exit_tree():
	MenuManager.unregister_menu(self)

## Here we connect the signals from the [member menu_signals].
func connect_signals():
	# --- Equipped ---
	# -- Button entered --
	menu_signals.weapon_equipped_button_entered.connect(_on_weapon_equipped_button_entered)
	menu_signals.armor_equipped_button_entered.connect(_on_armor_equipped_button_entered)
	menu_signals.accessory_equipped_button_entered.connect(_on_accessory_equipped_button_entered)
	menu_signals.head_equipped_button_entered.connect(_on_head_equipped_button_entered)
	menu_signals.shield_equipped_button_entered.connect(_on_shield_equipped_button_entered)
	# -- Button up --
	menu_signals.weapon_equipped_button_up.connect(_on_weapon_equipped_button_up)
	menu_signals.armor_equipped_button_up.connect(_on_armor_equipped_button_up)
	menu_signals.accessory_equipped_button_up.connect(_on_accessory_equipped_button_up)
	menu_signals.head_equipped_button_up.connect(_on_head_equipped_button_up)
	menu_signals.shield_equipped_button_up.connect(_on_shield_equipped_button_up)
	# --- Equip ---
	# -- Button entered --
	menu_signals.weapon_equip_button_entered.connect(_on_weapon_equip_button_entered)
	menu_signals.armor_equip_button_entered.connect(_on_armor_equip_button_entered)
	menu_signals.accessory_equip_button_entered.connect(_on_accessory_equip_button_entered)
	menu_signals.head_equip_button_entered.connect(_on_head_equip_button_entered)
	menu_signals.shield_equip_button_entered.connect(_on_shield_equip_button_entered)
	# -- Button up --
	menu_signals.weapon_equip_button_up.connect(_on_weapon_equip_button_up)
	menu_signals.armor_equip_button_up.connect(_on_armor_equip_button_up)
	menu_signals.accessory_equip_button_up.connect(_on_accessory_equip_button_up)
	menu_signals.head_equip_button_up.connect(_on_head_equip_button_up)
	menu_signals.shield_equip_button_up.connect(_on_shield_equip_button_up)

## Hide the scroll containers. When we give focus to the first button (weapon) in [method _ready], 
## it will show the scroll for the weapon automatically because of [method _on_weapon_equipped_button_entered].
func hide_scrolls():
	toggle_scroll(weapon_equip_scroll, false)
	toggle_scroll(armor_equip_scroll, false)
	toggle_scroll(accessory_equip_scroll, false)
	toggle_scroll(head_equip_scroll, false)
	toggle_scroll(shield_equip_scroll, false)

## Helper function to toggle scroll containers on/off, i.e., to show or hide.
func toggle_scroll(scroll: ScrollContainer, on: bool):
	scroll.show() if on else scroll.hide()

## Calls the individuals populate equipped buttons (slots) methods.
func populate_equipped_buttons():
	populate_weapon_equipped_button()
	populate_armor_equipped_button()
	populate_accessory_equipped_button()
	populate_head_equipped_button()
	populate_shield_equipped_button()

## Populate the equipped buttons (slots) for weapon.
func populate_weapon_equipped_button():
	if player.equip.weapon.item != null:
		weapon_equipped_button.weapon = player.equip.weapon.item
		weapon_equipped_name.text = player.equip.weapon.item.display_name
		weapon_equipped_icon.texture = player.equip.weapon.item.icon
	else:
		weapon_equipped_button.weapon = null
		weapon_equipped_name.text = ""
		weapon_equipped_icon.texture = null

## Populate the equipped buttons (slots) for armor.
func populate_armor_equipped_button():
	if player.equip.armor.item != null:
		armor_equipped_button.armor = player.equip.armor.item
		armor_equipped_name.text = player.equip.armor.item.display_name
		armor_equipped_icon.texture = player.equip.armor.item.icon
	else:
		armor_equipped_button.armor = null
		armor_equipped_name.text = ""
		armor_equipped_icon.texture = null

## Populate the equipped buttons (slots) for accessory.
func populate_accessory_equipped_button():
	if player.equip.accessory.item != null:
		accessory_equipped_button.accessory = player.equip.accessory.item
		accessory_equipped_name.text = player.equip.accessory.item.display_name
		accessory_equipped_icon.texture = player.equip.accessory.item.icon
	else:
		accessory_equipped_button.accessory = null
		accessory_equipped_name.text = ""
		accessory_equipped_icon.texture = null

## Populate the equipped buttons (slots) for head.
func populate_head_equipped_button():
	if player.equip.head.item != null:
		head_equipped_button.head = player.equip.head.item
		head_equipped_name.text = player.equip.head.item.display_name
		head_equipped_icon.texture = player.equip.head.item.icon
	else:
		head_equipped_button.head = null
		head_equipped_name.text = ""
		head_equipped_icon.texture = null

## Populate the equipped buttons (slots) for shield.
func populate_shield_equipped_button():
	if player.equip.shield.item != null:
		shield_equipped_button.shield = player.equip.shield.item
		shield_equipped_name.text = player.equip.shield.item.display_name
		shield_equipped_icon.texture = player.equip.shield.item.icon
	else:
		shield_equipped_button.shield = null
		shield_equipped_name.text = ""
		shield_equipped_icon.texture = null

## Calls the individuals populate equip buttons (inventory) methods.
func populate_equip_buttons():
	populate_weapon_equip_button()
	populate_armor_equip_button()
	populate_accessory_equip_button()
	populate_head_equip_button()
	populate_shield_equip_button()

## Populate the equip buttons (inventory) for weapon.
func populate_weapon_equip_button():
	# 1. Creates the unequip button
	var empty_container = weapon_equip_container.instantiate()
	var empty_button: WeaponEquipButton = empty_container.get_child(0)
	empty_button.weapon = null
	empty_button.quantity = 0
	
	empty_container.get_node("%WeaponEquipQuantity").text = ""
	empty_container.get_node("%WeaponEquipIcon").texture = null
	empty_container.get_node("%WeaponEquipName").text = "Remove Weapon"
	
	weapon_equip_v_box.add_child(empty_container)

	# 2. Loads equipment from inventory
	var weapons: Dictionary[Weapon, int] = GameManager.party.inventory.get_weapons()
	for weapon in weapons:
		#if weapon == null: continue # Prevents loading trash from the inventory
		
		var container = weapon_equip_container.instantiate()
		var button: WeaponEquipButton = container.get_child(0)
		button.weapon = weapon
		button.quantity = weapons[weapon]
		
		container.get_node("%WeaponEquipQuantity").text = "x" + str(button.quantity)
		container.get_node("%WeaponEquipIcon").texture = weapon.icon
		container.get_node("%WeaponEquipName").text = weapon.display_name
		
		weapon_equip_v_box.add_child(container)

## Populate the equip buttons (inventory) for armor.
func populate_armor_equip_button():
	# 1. Creates the unequip button
	var empty_container = armor_equip_container.instantiate()
	var empty_button: ArmorEquipButton = empty_container.get_child(0)
	empty_button.armor = null
	empty_button.quantity = 0
	
	empty_container.get_node("%ArmorEquipQuantity").text = ""
	empty_container.get_node("%ArmorEquipIcon").texture = null
	empty_container.get_node("%ArmorEquipName").text = "Remove Armor"
	
	armor_equip_v_box.add_child(empty_container)

	# 2. Loads equipment from inventory
	var armors: Dictionary[Armor, int] = GameManager.party.inventory.get_armors()
	for armor in armors:
		#if armor == null: continue # Prevents loading trash from the inventory
		
		var container = armor_equip_container.instantiate()
		var button: ArmorEquipButton = container.get_child(0)
		button.armor = armor
		button.quantity = armors[armor]
		
		container.get_node("%ArmorEquipQuantity").text = "x" + str(button.quantity)
		container.get_node("%ArmorEquipIcon").texture = armor.icon
		container.get_node("%ArmorEquipName").text = armor.display_name
		
		armor_equip_v_box.add_child(container)

## Populate the equip buttons (inventory) for accessory.
func populate_accessory_equip_button():
	# 1. Creates the unequip button
	var empty_container = accessory_equip_container.instantiate()
	var empty_button: AccessoryEquipButton = empty_container.get_child(0)
	empty_button.accessory = null
	empty_button.quantity = 0
	
	empty_container.get_node("%AccessoryEquipQuantity").text = ""
	empty_container.get_node("%AccessoryEquipIcon").texture = null
	empty_container.get_node("%AccessoryEquipName").text = "Remove Accessory"
	
	accessory_equip_v_box.add_child(empty_container)

	# 2. Loads equipment from inventory
	var accessories: Dictionary[Accessory, int] = GameManager.party.inventory.get_accessories()
	for accessory in accessories:
		#if accessory == null: continue # Prevents loading trash from the inventory
		
		var container = accessory_equip_container.instantiate()
		var button: AccessoryEquipButton = container.get_child(0)
		button.accessory = accessory
		button.quantity = accessories[accessory]
		
		container.get_node("%AccessoryEquipQuantity").text = "x" + str(button.quantity)
		container.get_node("%AccessoryEquipIcon").texture = accessory.icon
		container.get_node("%AccessoryEquipName").text = accessory.display_name
		
		accessory_equip_v_box.add_child(container)

## Populate the equip buttons (inventory) for head.
func populate_head_equip_button():
	# 1. Creates the unequip button
	var empty_container = head_equip_container.instantiate()
	var empty_button: HeadEquipButton = empty_container.get_child(0)
	empty_button.head = null
	empty_button.quantity = 0
	
	empty_container.get_node("%HeadEquipQuantity").text = ""
	empty_container.get_node("%HeadEquipIcon").texture = null
	empty_container.get_node("%HeadEquipName").text = "Remove Head"
	
	head_equip_v_box.add_child(empty_container)

	# 2. Loads equipment from inventory
	var heads: Dictionary[Head, int] = GameManager.party.inventory.get_heads()
	for head in heads:
		#if head == null: continue # Prevents loading trash from the inventory
		
		var container = head_equip_container.instantiate()
		var button: HeadEquipButton = container.get_child(0)
		button.head = head
		button.quantity = heads[head]
		
		container.get_node("%HeadEquipQuantity").text = "x" + str(button.quantity)
		container.get_node("%HeadEquipIcon").texture = head.icon
		container.get_node("%HeadEquipName").text = head.display_name
		
		head_equip_v_box.add_child(container)

## Populate the equip buttons (inventory) for shield.
func populate_shield_equip_button():
	# 1. Creates the unequip button
	var empty_container = shield_equip_container.instantiate()
	var empty_button: ShieldEquipButton = empty_container.get_child(0)
	empty_button.shield = null
	empty_button.quantity = 0
	
	empty_container.get_node("%ShieldEquipQuantity").text = ""
	empty_container.get_node("%ShieldEquipIcon").texture = null
	empty_container.get_node("%ShieldEquipName").text = "Remove Shield"
	
	shield_equip_v_box.add_child(empty_container)

	# 2. Loads equipment from inventory
	var shields: Dictionary[Shield, int] = GameManager.party.inventory.get_shields()
	for shield in shields:
		#if shield == null: continue # Prevents loading trash from the inventory
		
		var container = shield_equip_container.instantiate()
		var button: ShieldEquipButton = container.get_child(0)
		button.shield = shield
		button.quantity = shields[shield]
		
		container.get_node("%ShieldEquipQuantity").text = "x" + str(button.quantity)
		container.get_node("%ShieldEquipIcon").texture = shield.icon
		container.get_node("%ShieldEquipName").text = shield.display_name
		
		shield_equip_v_box.add_child(container)

## This method is used to control the flow inside equip menu and to prevents errors when
## pressing [i]cancel[/] input with the main menu.
func handle_back() -> bool:
	if current_state == States.ITEM_SELECTION:
		back_to_slot_selection()
		return true
	
	return false

## Get back to slot selection phase. See more in [enum States].
func back_to_slot_selection():
	current_state = States.SLOT_SELECTION
	last_focused_slot.grab_focus()

## Go to item selection (inventory) phase.
func open_item_selection(v_box: VBoxContainer, slot_button: Control, equip: ItemEquippable):
	current_state = States.ITEM_SELECTION
	last_focused_slot = slot_button
	
	var first_container = v_box.get_child(0)
	var first_button = first_container.get_child(0)
	first_button.grab_focus()

# Clear the equip (inventory) lists.
func clear_equip_lists():
	for child in weapon_equip_v_box.get_children():
		child.queue_free()
	for child in armor_equip_v_box.get_children():
		child.queue_free()
	for child in accessory_equip_v_box.get_children():
		child.queue_free()
	for child in head_equip_v_box.get_children():
		child.queue_free()
	for child in shield_equip_v_box.get_children():
		child.queue_free()

# --- Connected functions ---
# -- Equipped --
# - Button entered -
func _on_weapon_equipped_button_entered(weapon: Weapon):
	toggle_scroll(weapon_equip_scroll, true)
	messenger_label.text = weapon.description if weapon else ""
	toggle_scroll(armor_equip_scroll, false)
	
func _on_armor_equipped_button_entered(armor: Armor):
	toggle_scroll(armor_equip_scroll, true)
	messenger_label.text = armor.description if armor else ""
	toggle_scroll(accessory_equip_scroll, false)
	toggle_scroll(weapon_equip_scroll, false)
	
func _on_accessory_equipped_button_entered(accessory: Accessory):
	toggle_scroll(accessory_equip_scroll, true)
	messenger_label.text = accessory.description if accessory else ""
	toggle_scroll(head_equip_scroll, false)
	toggle_scroll(armor_equip_scroll, false)
	
func _on_head_equipped_button_entered(head: Head):
	toggle_scroll(head_equip_scroll, true)
	messenger_label.text = head.description if head else ""
	toggle_scroll(shield_equip_scroll, false)
	toggle_scroll(accessory_equip_scroll, false)
	
func _on_shield_equipped_button_entered(shield: Shield):
	toggle_scroll(shield_equip_scroll, true)
	messenger_label.text = shield.description if shield else ""
	toggle_scroll(head_equip_scroll, false)
	
# - Button up -
func _on_weapon_equipped_button_up(weapon: Weapon):
	open_item_selection(weapon_equip_v_box, weapon_equipped_button, weapon)
	
func _on_armor_equipped_button_up(armor: Armor):
	open_item_selection(armor_equip_v_box, armor_equipped_button, armor)
	
func _on_accessory_equipped_button_up(accessory: Accessory):
	open_item_selection(accessory_equip_v_box, accessory_equipped_button, accessory)
	
func _on_head_equipped_button_up(head: Head):
	open_item_selection(head_equip_v_box, head_equipped_button, head)

func _on_shield_equipped_button_up(shield: Shield):
	open_item_selection(shield_equip_v_box, shield_equipped_button, shield)

# -- Equip --
# - Button entered -
func _on_weapon_equip_button_entered(weapon: Weapon):
	if weapon == null:
		messenger_label.text = "Removes the current weapon."
	else:
		messenger_label.text = weapon.description
	
func _on_armor_equip_button_entered(armor: Armor):
	if armor == null:
		messenger_label.text = "Removes the current armor."
	else:
		messenger_label.text = armor.description
	
func _on_accessory_equip_button_entered(accessory: Accessory):
	if accessory == null:
		messenger_label.text = "Removes the current accessory."
	else:
		messenger_label.text = accessory.description
	
func _on_head_equip_button_entered(head: Head):
	if head == null:
		messenger_label.text = "Removes the current head."
	else:
		messenger_label.text = head.description
	
func _on_shield_equip_button_entered(shield: Shield):
	if shield == null:
		messenger_label.text = "Removes the current shield."
	else:
		messenger_label.text = shield.description
	
# - Button up -
func _on_weapon_equip_button_up(new_weapon: Weapon):
	var old_weapon = player.equip.weapon.item
	if old_weapon == new_weapon:
		back_to_slot_selection()
		return
	
	var slot = WeaponSlot.new()
	var removed_item = player.change_equipment(slot, new_weapon)

	if removed_item != null:
		GameManager.party.inventory.add_item(removed_item, 1)
	if new_weapon != null:
		GameManager.party.inventory.remove_item(new_weapon, 1)

	populate_equipped_buttons()
	clear_equip_lists()
	populate_equip_buttons()
	back_to_slot_selection()
	
func _on_armor_equip_button_up(new_armor: Armor):
	var old_armor = player.equip.armor.item
	if old_armor == new_armor:
		back_to_slot_selection()
		return
	
	var slot = ArmorSlot.new()
	var removed_item = player.change_equipment(slot, new_armor)

	if removed_item != null:
		GameManager.party.inventory.add_item(removed_item, 1)
	if new_armor != null:
		GameManager.party.inventory.remove_item(new_armor, 1)

	populate_equipped_buttons()
	clear_equip_lists()
	populate_equip_buttons()
	back_to_slot_selection()
	
func _on_accessory_equip_button_up(new_accessory: Accessory):
	var old_accessory = player.equip.accessory.item
	if old_accessory == new_accessory:
		back_to_slot_selection()
		return
	
	var slot = AccessorySlot.new()
	var removed_item = player.change_equipment(slot, new_accessory)

	if removed_item != null:
		GameManager.party.inventory.add_item(removed_item, 1)
	if new_accessory != null:
		GameManager.party.inventory.remove_item(new_accessory, 1)

	populate_equipped_buttons()
	clear_equip_lists()
	populate_equip_buttons()
	back_to_slot_selection()
	
func _on_head_equip_button_up(new_head: Head):
	var old_head = player.equip.head.item
	if old_head == new_head:
		back_to_slot_selection()
		return
	
	var slot = HeadSlot.new()
	var removed_item = player.change_equipment(slot, new_head)

	if removed_item != null:
		GameManager.party.inventory.add_item(removed_item, 1)
	if new_head != null:
		GameManager.party.inventory.remove_item(new_head, 1)

	populate_equipped_buttons()
	clear_equip_lists()
	populate_equip_buttons()
	back_to_slot_selection()
	
func _on_shield_equip_button_up(new_shield: Shield):
	var old_shield = player.equip.shield.item
	if old_shield == new_shield:
		back_to_slot_selection()
		return
	
	var slot = WeaponSlot.new()
	var removed_item = player.change_equipment(slot, new_shield)

	if removed_item != null:
		GameManager.party.inventory.add_item(removed_item, 1)
	if new_shield != null:
		GameManager.party.inventory.remove_item(new_shield, 1)

	populate_equipped_buttons()
	clear_equip_lists()
	populate_equip_buttons()
	back_to_slot_selection()
