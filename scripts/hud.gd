extends CanvasLayer

var barra_vida: ProgressBar
var puntos_label: Label
var pausa_btn: Button
var pausa_menu: Node
var btn_continuar: Button
var btn_salir: Button
var btn_reiniciar: Button

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	barra_vida    = get_node_or_null("MarginContainer/HBoxContainer/VBoxContainer/ProgressBar")
	puntos_label  = get_node_or_null("MarginContainer/HBoxContainer/puntos")
	pausa_btn     = get_node_or_null("MarginContainer/HBoxContainer/pausa")
	pausa_menu    = get_node_or_null("menuPausa")
	btn_continuar = get_node_or_null("menuPausa/ColorRect/VBoxContainer/continuar")
	btn_reiniciar = get_node_or_null("menuPausa/ColorRect/VBoxContainer/reiniciar")
	btn_salir     = get_node_or_null("menuPausa/ColorRect/VBoxContainer/salir")

	if barra_vida:
		barra_vida.min_value = 0
		barra_vida.max_value = 100
		barra_vida.value     = 100

	if pausa_menu:   pausa_menu.visible = false
	if pausa_btn:    pausa_btn.pressed.connect(_on_pausa_pressed)
	if btn_continuar: btn_continuar.pressed.connect(_on_continuar_pressed)
	if btn_reiniciar: btn_reiniciar.pressed.connect(_on_reiniciar_pressed)
	if btn_salir:     btn_salir.pressed.connect(_on_salir_pressed)

func update_score(new_score: int):
	if puntos_label:
		puntos_label.text = str(new_score)
		animar_puntos()

func animar_puntos():
	#Crea un label temporal encima del de puntos
	var label = Label.new()
	label.text = "+" + str(puntos_label.text)
	label.add_theme_color_override("font_color", Color.RED)
	label.position = puntos_label.global_position + Vector2(0, -10)
	label.z_index = 10
	add_child(label)
	
	#Sube y se desvanece
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y - 40, 0.8)
	tween.tween_property(label, "modulate:a", 0.0, 0.8)
	tween.tween_callback(label.queue_free).set_delay(0.8)
	
	#Pequeño rebote en el label principal
	var tween2 = create_tween()
	tween2.tween_property(puntos_label, "scale", Vector2(1.4, 1.4), 0.1)
	tween2.tween_property(puntos_label, "scale", Vector2(1.0, 1.0), 0.15)

func update_vida(vida_actual: int, vida_maxima: int):
	if barra_vida:
		barra_vida.max_value = vida_maxima
		barra_vida.value     = vida_actual

func _on_pausa_pressed():
	get_tree().paused = !get_tree().paused
	if pausa_menu:
		pausa_menu.visible = get_tree().paused

func _on_continuar_pressed():
	get_tree().paused = false
	if pausa_menu: pausa_menu.visible = false

func _on_reiniciar_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_salir_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
