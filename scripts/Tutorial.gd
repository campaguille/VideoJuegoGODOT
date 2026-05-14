extends Node2D

#1. Defino la lista de textos
var textos_tutorial = [
	"HISTORIA: Eres el Dr. Palomo. Un médico... una mordedura radioactiva... y un tumor que lo cambiará todo.",
	"MOVIMIENTO: Usa las FLECHAS DEL TECLADO para moverte por el parque y esquivar a esas molestas ardillas.",
	"APUNTADO: El Doctor Palomo siempre mirará hacia donde apunte el PUNTERO DEL RATÓN.",
	"DISPARO: Pulsa la tecla ESPACIO para abrir fuego. ¡Cuidado con los gorriones, disparan rápido!",
	"CURACIÓN: El alpiste recupera vida y el bocadillo te cura por completo. No te fíes de las pastillas...",
	"FURIA: Si el tumor cerebral hace efecto, los controles se volverán locos. ¡Úsalo a tu favor!",
	"¡RECUERDA!: Si bebes demasiada cerveza, se acabó la partida. ¡A por ellos!"
]

#2. Variable para saber en qué página estamos
var indice_actual = 0

#Referencias a los nodos
@onready var etiqueta_texto = $instrucciones
@onready var btn_anterior = $btnAnterior
@onready var btn_siguiente = $btnSiguiente
@onready var btn_jugar = $btnJugar

func _ready():
	actualizar_interfaz()

func actualizar_interfaz():
	#Cambiamos el texto al que corresponde según el índice
	etiqueta_texto.text = textos_tutorial[indice_actual]
	
	#Lógica de visibilidad de botones
	btn_anterior.visible = (indice_actual > 0) #Ocultar si es el primero
	btn_siguiente.visible = (indice_actual < textos_tutorial.size() - 1)
	
	#Mostrar el botón jugar solo en la última diapositiva
	if btn_jugar:
		btn_jugar.visible = (indice_actual == textos_tutorial.size() - 1)


func _on_btn_siguiente_pressed():
	if indice_actual < textos_tutorial.size() - 1:
		indice_actual += 1
		actualizar_interfaz()

func _on_btn_anterior_pressed():
	if indice_actual > 0:
		indice_actual -= 1
		actualizar_interfaz()

func _on_btn_jugar_pressed():
	get_tree().change_scene_to_file("res://scenes/GameScene.tscn")
