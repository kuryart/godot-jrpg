class_name MapAudioPlayer2D extends AudioStreamPlayer2D

@export var sfx_bank: SFXBank
@export var sfx_key: String
@export var play_on_start: bool = false

func _ready() -> void:
	if sfx_bank and sfx_bank.bank.has(sfx_key):
		var sfx: SFX = sfx_bank.bank[sfx_key]
		stream = sfx.stream
		bus = sfx.bus
		volume_db += sfx.volume_db
		pitch_scale *= sfx.pitch_scale
		
		if play_on_start:
			play()
	else:
		push_warning("MapAudioPlayer2D: Áudio '", sfx_key, "' não encontrado no banco.")

func play_sfx() -> void:
	play()
