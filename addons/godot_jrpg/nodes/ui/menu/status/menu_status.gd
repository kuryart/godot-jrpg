class_name MenuStatus extends Control

@onready var hp_label: BarLabel = %HPCurrent
@onready var hp_bar: Bar = %HPBar
@onready var mp_label: BarLabel = %MPCurrent
@onready var mp_bar: Bar = %MPBar
@onready var attack: Label = %AttackValue
@onready var defense: Label = %DefenseValue
@onready var intelligence: Label = %IntelligenceValue
@onready var speed: Label = %SpeedValue
@onready var accuracy: Label = %AccuracyValue
@onready var evasion: Label = %EvasionValue
@onready var luck: Label = %LuckValue
@onready var status_container: HBoxContainer = %StatusContainer
@onready var face_player: TextureRect = %FacePlayer
@onready var name_player: Label = %NamePlayer

@export var player: Player
@export var status_icon: PackedScene

func _ready() -> void:
	MenuManager.register_menu(self)
	set_player_name()
	set_player_face()
	set_hp()
	set_mp()
	set_attack()
	set_defense()
	set_intelligence()
	set_speed()
	set_accuracy()
	set_evasion()
	set_luck()
	set_status()

func _exit_tree():
	MenuManager.unregister_menu(self)

func set_player_name():
	name_player.text = player.name

func set_player_face():
	face_player.texture = player.face

func set_hp():
	var max_hp = player.get_max_hp()
	var current_hp = player.current_hp
	hp_bar.max_value = max_hp
	hp_bar.value = current_hp
	hp_label.text = str(current_hp) + "/" + str(max_hp)
	
func set_mp():
	var max_mp = player.get_max_mp()
	var current_mp = player.current_mp
	mp_bar.max_value = max_mp
	mp_bar.value = current_mp
	mp_label.text = str(current_mp) + "/" + str(max_mp)

func set_attack():
	attack.text = str(player.get_attack())

func set_defense():
	defense.text = str(player.get_defense())

func set_intelligence():
	intelligence.text = str(player.get_intelligence())

func set_speed():
	speed.text = str(player.get_speed())

func set_accuracy():
	accuracy.text = str(player.get_accuracy())

func set_evasion():
	evasion.text = str(player.get_evasion())

func set_luck():
	luck.text = str(player.get_luck())

func set_status():
	for s in player.status:
		var status_icon_instance: TextureRect = status_icon.instantiate() as TextureRect
		status_icon_instance.texture = s.icon
		status_container.add_child(status_icon_instance)
		
