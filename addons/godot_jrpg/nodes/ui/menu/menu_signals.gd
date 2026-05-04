class_name MenuSignals extends Resource

# --- Open menus ---
signal open_menu_items_emited
signal open_menu_skills_emited
signal open_menu_equip_emited
signal open_menu_status_emited
signal open_menu_save_emited

# --- Player menu ---
signal menu_player_selected(player: Player)

# --- Save menu ---
signal save_old_file_emited
signal save_new_file_emited

# --- Items menu ---
signal item_clicked
signal item_changed
signal menu_items_player_selected(player: Player)

# --- Equip menu ---
# -- Equipped buttons --
# - Focus entered -
signal weapon_equipped_button_entered(weapon: Weapon)
signal armor_equipped_button_entered(armor: Armor)
signal accessory_equipped_button_entered(accessory: Accessory)
signal head_equipped_button_entered(head: Head)
signal shield_equipped_button_entered(shield: Shield)
# - Button up -
signal weapon_equipped_button_up(weapon: Weapon)
signal armor_equipped_button_up(armor: Armor)
signal accessory_equipped_button_up(accessory: Accessory)
signal head_equipped_button_up(head: Head)
signal shield_equipped_button_up(shield: Shield)
# -- Equip buttons --
# - Focus entered -
signal weapon_equip_button_entered(weapon: Weapon)
signal armor_equip_button_entered(armor: Armor)
signal accessory_equip_button_entered(accessory: Accessory)
signal head_equip_button_entered(head: Head)
signal shield_equip_button_entered(shield: Weapon)
# - Button up -
signal weapon_equip_button_up(weapon: Weapon, name: Label, icon: TextureRect)
signal armor_equip_button_up(armor: Armor, name: Label, icon: TextureRect)
signal accessory_equip_button_up(accessory: Accessory, name: Label, icon: TextureRect)
signal head_equip_button_up(head: Head, name: Label, icon: TextureRect)
signal shield_equip_button_up(shield: Weapon, name: Label, icon: TextureRect)
