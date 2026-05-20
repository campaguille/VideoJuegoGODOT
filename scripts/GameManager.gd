extends Node

var volumen_musica: float = 1.0
var volumen_efectos: float = 1.0
var pantalla_fullscreen: bool = false
var accesorio_cabeza: String = "Ninguno"
var accesorio_cara: String = "Ninguno"
var accesorio_cuerpo: String = "Ninguno"

func _ready():
	cargar()

func guardar():
	var data = {
		"volumen_musica": volumen_musica,
		"volumen_efectos": volumen_efectos,
		"pantalla_fullscreen": pantalla_fullscreen,
		"accesorio_cabeza": accesorio_cabeza,
		"accesorio_cara": accesorio_cara,
		"accesorio_cuerpo": accesorio_cuerpo
	}
	var file = FileAccess.open("user://ajustes.save", FileAccess.WRITE)
	if file:
		file.store_var(data)
		file.close()

func cargar():
	if not FileAccess.file_exists("user://ajustes.save"):
		return
	var file = FileAccess.open("user://ajustes.save", FileAccess.READ)
	if file:
		var data = file.get_var()
		file.close()
		volumen_musica = data.get("volumen_musica", 1.0)
		volumen_efectos = data.get("volumen_efectos", 1.0)
		pantalla_fullscreen = data.get("pantalla_fullscreen", false)
		accesorio_cabeza = data.get("accesorio_cabeza", "Ninguno")
		accesorio_cara = data.get("accesorio_cara", "Ninguno")
		accesorio_cuerpo = data.get("accesorio_cuerpo", "Ninguno")
		aplicar_configuracion()

func aplicar_configuracion():
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		linear_to_db(volumen_musica)
	)
	if pantalla_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

# CONTROL DE PROGRESIÓN DE NIVELES
func verificar_enemigos_vivos():
	# Esperamos un frame para asegurar que el enemigo realmente haya sido eliminado de la escena
	await get_tree().physics_frame
	
	# Contamos cuántos enemigos quedan en el grupo "enemy"
	var enemigos_restantes = get_tree().get_nodes_in_group("enemy").size()
	
	if enemigos_restantes == 0:
		var ruta = get_tree().current_scene.scene_file_path
		
		# Lógica de progresión basada en el nombre del archivo de la escena actual
		if "GameScene" in ruta:
			get_tree().change_scene_to_file("res://scenes/Nivel2.tscn")
			
		elif "Nivel2" in ruta:
			get_tree().change_scene_to_file("res://scenes/Nivel3.tscn")
			
		elif "Nivel3" in ruta:
			# Al terminar el último nivel, volvemos al menú
			get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
