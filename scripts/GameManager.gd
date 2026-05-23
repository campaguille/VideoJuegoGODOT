extends Node

var volumen_musica: float = 1.0
var volumen_efectos: float = 1.0
var pantalla_fullscreen: bool = false
var accesorio_cabeza: String = "Ninguno"
var accesorio_cara: String = "Ninguno"
var accesorio_cuerpo: String = "Ninguno"
var puntos_finales: int = 0

const NIVELES = [
	"res://scenes/GameScene.tscn",
	"res://scenes/Nivel2.tscn",
    "res://scenes/Nivel3.tscn"
]

var nivel_actual: int = 0
var transition_scene = preload("res://scenes/transicion.tscn")

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

func verificar_enemigos_vivos():
	get_tree().physics_frame
	
	var enemigos_restantes = get_tree().get_nodes_in_group("enemy").size()
	if enemigos_restantes == 0:
		_ir_siguiente_nivel()

func _ir_siguiente_nivel():
	var transition = transition_scene.instantiate()
	transition.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().get_root().add_child(transition)
	
	await transition.fade_in(0.6)
	
	var ruta = get_tree().current_scene.scene_file_path
	if "GameScene" in ruta:
		get_tree().change_scene_to_file("res://scenes/Nivel2.tscn")
	elif "Nivel2" in ruta:
		get_tree().change_scene_to_file("res://scenes/Nivel3.tscn")
	elif "Nivel3" in ruta:
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
		return
	
	await get_tree().process_frame
	await transition.fade_out(0.6)
	transition.queue_free()
