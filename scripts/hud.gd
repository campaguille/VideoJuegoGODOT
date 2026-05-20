extends CanvasLayer

@onready var puntos = $MarginContainer/HBoxContainer/PanelContainer/HBoxContainer/puntos
@onready var pausa = $MarginContainer/HBoxContainer/pausa
@onready var pausa_menu = $menuPausa
@onready var btn_continuar = $menuPausa/ColorRect/VBoxContainer/continuar
@onready var btn_salir = $menuPausa/ColorRect/VBoxContainer/salir
@onready var btn_reiniciar = $menuPausa/ColorRect/VBoxContainer/reiniciar


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	pausa.pressed.connect(_on_pausa_pressed)
	btn_continuar.pressed.connect(_on_continuar_pressed)
	btn_salir.pressed.connect(_on_salir_pressed)
	btn_reiniciar.pressed.connect(_on_reiniciar_pressed)
	pausa_menu.visible = false  #oculto al inicio

func update_score(new_score: int):
	puntos.text = str(new_score)

func _on_pausa_pressed():
	get_tree().paused = !get_tree().paused
	pausa_menu.visible = get_tree().paused
	pausa.text = "⏵" if get_tree().paused else "‖"
	
func _on_continuar_pressed():
	get_tree().paused = false
	pausa_menu.visible = false
	pausa.text = "‖"

func _on_salir_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	
func _on_reiniciar_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
