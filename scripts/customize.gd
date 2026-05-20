extends Control

# CORRECCIÓN: Quitamos el .new() que duplicaba el script en memoria
# Ahora usa directamente el Autoload global de tu proyecto

var slider_musica: HSlider
var slider_efectos: HSlider
var checkbox_pantalla: CheckBox

func _ready():
	GameManager.cargar()

	var fondo = TextureRect.new()
	fondo.texture = load("res://assets/sprites/FondoPantallaInicio.png")
	fondo.set_anchors_preset(Control.PRESET_FULL_RECT)
	fondo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(fondo)

	var titulo = Label.new()
	titulo.text = "AJUSTES"
	titulo.set_anchors_preset(Control.PRESET_TOP_WIDE)
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo.add_theme_font_size_override("font_size", 80)
	titulo.position = Vector2(0, 40)
	add_child(titulo)

	var panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(900, 500)
	panel.position = Vector2(-450, -250)
	add_child(panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 30)
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.add_child(vbox)

	var lbl_musica = Label.new()
	lbl_musica.text = "Volumen Música"
	lbl_musica.add_theme_font_size_override("font_size", 40)
	vbox.add_child(lbl_musica)

	slider_musica = HSlider.new()
	slider_musica.min_value = 0.0
	slider_musica.max_value = 1.0
	slider_musica.step = 0.01
	slider_musica.custom_minimum_size = Vector2(0, 50)
	vbox.add_child(slider_musica)

	var lbl_efectos = Label.new()
	lbl_efectos.text = "Volumen Efectos"
	lbl_efectos.add_theme_font_size_override("font_size", 40)
	vbox.add_child(lbl_efectos)

	slider_efectos = HSlider.new()
	slider_efectos.min_value = 0.0
	slider_efectos.max_value = 1.0
	slider_efectos.step = 0.01
	slider_efectos.custom_minimum_size = Vector2(0, 50)
	vbox.add_child(slider_efectos)

	var lbl_pantalla = Label.new()
	lbl_pantalla.text = "Pantalla Completa"
	lbl_pantalla.add_theme_font_size_override("font_size", 40)
	vbox.add_child(lbl_pantalla)

	checkbox_pantalla = CheckBox.new()
	checkbox_pantalla.text = "Activar pantalla completa"
	checkbox_pantalla.add_theme_font_size_override("font_size", 35)
	vbox.add_child(checkbox_pantalla)

	var hbox = HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 40)
	vbox.add_child(hbox)

	var btn_guardar = Button.new()
	btn_guardar.text = "GUARDAR"
	btn_guardar.custom_minimum_size = Vector2(200, 70)
	btn_guardar.add_theme_font_size_override("font_size", 40)
	btn_guardar.pressed.connect(_on_btn_guardar_pressed)
	hbox.add_child(btn_guardar)

	var btn_volver = Button.new()
	btn_volver.text = "VOLVER"
	btn_volver.custom_minimum_size = Vector2(200, 70)
	btn_volver.add_theme_font_size_override("font_size", 40)
	btn_volver.pressed.connect(_on_btn_volver_pressed)
	hbox.add_child(btn_volver)

	cargar_valores()

func cargar_valores():
	slider_musica.value = GameManager.volumen_musica
	slider_efectos.value = GameManager.volumen_efectos
	checkbox_pantalla.button_pressed = GameManager.pantalla_fullscreen

func _on_btn_guardar_pressed():
	GameManager.volumen_musica = slider_musica.value
	GameManager.volumen_efectos = slider_efectos.value
	GameManager.pantalla_fullscreen = checkbox_pantalla.button_pressed
	GameManager.guardar()
	GameManager.aplicar_configuracion()

func _on_btn_volver_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
