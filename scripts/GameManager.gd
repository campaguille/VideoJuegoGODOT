extends Node

var volumen_musica: float = 1.0
var volumen_efectos: float = 1.0
var pantalla_fullscreen: bool = false

var music_player: AudioStreamPlayer
var sfx_players: Array = [] 


func _ready():
	# Busca automáticamente el reproductor de música en la escena
	music_player = get_tree().root.find_child("MusicPlayer", true, false)

	# Busca todos los efectos de sonido
	sfx_players = get_tree().root.find_children("SFX", true, false)

	cargar()
	aplicar_configuracion()


func guardar():
	var data = {
		"volumen_musica": volumen_musica,
		"volumen_efectos": volumen_efectos,
		"pantalla_fullscreen": pantalla_fullscreen
	}

	var file = FileAccess.open("user://ajustes.save", FileAccess.WRITE)
	file.store_var(data)
	file.close()


func cargar():
	if not FileAccess.file_exists("user://ajustes.save"):
		return

	var file = FileAccess.open("user://ajustes.save", FileAccess.READ)
	var data = file.get_var()
	file.close()

	volumen_musica = data.get("volumen_musica", 1.0)
	volumen_efectos = data.get("volumen_efectos", 1.0)
	pantalla_fullscreen = data.get("pantalla_fullscreen", false)


func aplicar_configuracion():
	# Música directa sin buses
	if music_player:
		music_player.volume_db = linear_to_db(volumen_musica)

	# Efectos directos sin buses
	for sfx in sfx_players:
		sfx.volume_db = linear_to_db(volumen_efectos)

	# Pantalla completa
	if pantalla_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
