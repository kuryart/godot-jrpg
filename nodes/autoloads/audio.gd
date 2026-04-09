extends Node

@export var sfx_bank: SFXBank = preload("uid://bglecu7o2iv1v") 
@export var music_bank: MusicBank = preload("uid://dua0ynuhyda1a") 

var music_player: AudioStreamPlayer
var is_sound_canceled: bool

func play_sfx(sfx: SFX, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	var sfx_player := AudioStreamPlayer.new()
	sfx_player.bus = sfx.bus
	sfx_player.stream = sfx.stream
	sfx_player.volume_db = sfx.volume_db if volume_db == 0.0 else volume_db
	sfx_player.pitch_scale = sfx.pitch_scale if pitch_scale == 1.0 else pitch_scale
	add_child(sfx_player)
	sfx_player.play()
	await sfx_player.finished
	sfx_player.queue_free()
	
func play_music(music: Music, volume_override: float = 0.0, pitch_override: float = 1.0) -> void:
	if not music_player:
		music_player = AudioStreamPlayer.new()
		add_child(music_player)
	music_player.stop()
	music_player.bus = music.bus
	music_player.stream = music.stream
	music_player.volume_db = music.volume_db if volume_override == 0.0 else volume_override
	music_player.pitch_scale = music.pitch_scale if pitch_override == 1.0 else pitch_override
	music_player.play()

## This function is used to cancel sounds played by UIButton when exiting or entering focus. Use Audio.cancel_sound() on the UIButton object to deny the sound.
func cancel_sound() -> void:
	is_sound_canceled = true
	await get_tree().process_frame
	is_sound_canceled = false
