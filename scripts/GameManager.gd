extends Node

# Audio
var volumen_musica: float = 1.0
var volumen_efectos: float = 1.0

# Pantalla
var pantalla_fullscreen: bool = false

# Aspecto del jugador
var accesorio_cabeza: String = "ninguno"
var accesorio_cara: String = "ninguno"
var accesorio_cuerpo: String = "ninguno"

# Guardar configuración
func guardar():
	var config = ConfigFile.new()
	config.set_value("audio", "musica", volumen_musica)
	config.set_value("audio", "efectos", volumen_efectos)
	config.set_value("pantalla", "fullscreen", pantalla_fullscreen)
	config.set_value("aspecto", "cabeza", accesorio_cabeza)
	config.set_value("aspecto", "cara", accesorio_cara)
	config.set_value("aspecto", "cuerpo", accesorio_cuerpo)
	config.save("user://config.cfg")

# Cargar configuración
func cargar():
	var config = ConfigFile.new()
	if config.load("user://config.cfg") == OK:
		volumen_musica = config.get_value("audio", "musica", 1.0)
		volumen_efectos = config.get_value("audio", "efectos", 1.0)
		pantalla_fullscreen = config.get_value("pantalla", "fullscreen", false)
		accesorio_cabeza = config.get_value("aspecto", "cabeza", "ninguno")
		accesorio_cara = config.get_value("aspecto", "cara", "ninguno")
		accesorio_cuerpo = config.get_value("aspecto", "cuerpo", "ninguno")
		aplicar_configuracion()

# Aplicar la configuración al juego
func aplicar_configuracion():
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		linear_to_db(volumen_musica)
	)
	if pantalla_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _ready():
	cargar()
