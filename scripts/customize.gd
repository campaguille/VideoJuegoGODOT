extends Control

var slider_musica: HSlider
var slider_efectos: HSlider
var checkbox_pantalla: CheckBox
var opt_cabeza: OptionButton
var opt_cara: OptionButton
var opt_cuerpo: OptionButton

func _ready():
	# Fondo
	var fondo = TextureRect.new()
	fondo.texture = load("res://assets/sprites/FondoPantallaInicio.png")
	fondo.set_anchors_preset(Control.PRESET_FULL_RECT)
	fondo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(fondo)

	# Título
	var titulo = Label.new()
	titulo.text = "PERSONALIZAR"
	titulo.set_anchors_preset(Control.PRESET_TOP_WIDE)
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo.add_theme_font_size_override("font_size", 80)
	titulo.position = Vector2(0, 40)
	add_child(titulo)

	# Panel semitransparente de fondo
	var panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(900, 700)
	panel.position = Vector2(-450, -350)
	add_child(panel)

	# VBox principal dentro del panel
	var vbox_principal = VBoxContainer.new()
	vbox_principal.add_theme_constant_override("separation", 20)
	vbox_principal.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.add_child(vbox_principal)

	# TabContainer
	var tab = TabContainer.new()
	tab.custom_minimum_size = Vector2(0, 550)
	vbox_principal.add_child(tab)

	# Pestaña Sonido
	var p_sonido = VBoxContainer.new()
	p_sonido.name = "Sonido"
	p_sonido.add_theme_constant_override("separation", 30)
	tab.add_child(p_sonido)

	var lbl_musica = Label.new()
	lbl_musica.text = "Volumen Música"
	lbl_musica.add_theme_font_size_override("font_size", 40)
	p_sonido.add_child(lbl_musica)

	slider_musica = HSlider.new()
	slider_musica.min_value = 0.0
	slider_musica.max_value = 1.0
	slider_musica.step = 0.01
	slider_musica.value = 1.0
	slider_musica.custom_minimum_size = Vector2(0, 50)
	p_sonido.add_child(slider_musica)

	var lbl_efectos = Label.new()
	lbl_efectos.text = "Volumen Efectos"
	lbl_efectos.add_theme_font_size_override("font_size", 40)
	p_sonido.add_child(lbl_efectos)

	slider_efectos = HSlider.new()
	slider_efectos.min_value = 0.0
	slider_efectos.max_value = 1.0
	slider_efectos.step = 0.01
	slider_efectos.value = 1.0
	slider_efectos.custom_minimum_size = Vector2(0, 50)
	p_sonido.add_child(slider_efectos)

	# Pestaña Pantalla
	var p_pantalla = VBoxContainer.new()
	p_pantalla.name = "Pantalla"
	p_pantalla.add_theme_constant_override("separation", 30)
	tab.add_child(p_pantalla)

	var lbl_pantalla = Label.new()
	lbl_pantalla.text = "Pantalla Completa"
	lbl_pantalla.add_theme_font_size_override("font_size", 40)
	p_pantalla.add_child(lbl_pantalla)

	checkbox_pantalla = CheckBox.new()
	checkbox_pantalla.text = "Activar pantalla completa"
	checkbox_pantalla.add_theme_font_size_override("font_size", 35)
	p_pantalla.add_child(checkbox_pantalla)

	# Pestaña Aspecto
	var p_aspecto = VBoxContainer.new()
	p_aspecto.name = "Aspecto"
	p_aspecto.add_theme_constant_override("separation", 20)
	tab.add_child(p_aspecto)

	var lbl_cabeza = Label.new()
	lbl_cabeza.text = "Cabeza"
	lbl_cabeza.add_theme_font_size_override("font_size", 40)
	p_aspecto.add_child(lbl_cabeza)

	opt_cabeza = OptionButton.new()
	opt_cabeza.add_item("Ninguno")
	opt_cabeza.add_item("Gorro Peruano")
	opt_cabeza.add_item("Chistera")
	opt_cabeza.custom_minimum_size = Vector2(0, 60)
	opt_cabeza.add_theme_font_size_override("font_size", 35)
	p_aspecto.add_child(opt_cabeza)

	var lbl_cara = Label.new()
	lbl_cara.text = "Cara"
	lbl_cara.add_theme_font_size_override("font_size", 40)
	p_aspecto.add_child(lbl_cara)

	opt_cara = OptionButton.new()
	opt_cara.add_item("Ninguno")
	opt_cara.add_item("Barba")
	opt_cara.add_item("Gafas de Sol")
	opt_cara.add_item("Cicatriz")
	opt_cara.custom_minimum_size = Vector2(0, 60)
	opt_cara.add_theme_font_size_override("font_size", 35)
	p_aspecto.add_child(opt_cara)

	var lbl_cuerpo = Label.new()
	lbl_cuerpo.text = "Cuerpo"
	lbl_cuerpo.add_theme_font_size_override("font_size", 40)
	p_aspecto.add_child(lbl_cuerpo)

	opt_cuerpo = OptionButton.new()
	opt_cuerpo.add_item("Ninguno")
	opt_cuerpo.add_item("Bandera de España")
	opt_cuerpo.add_item("Lazo")
	opt_cuerpo.add_item("Barriga")
	opt_cuerpo.custom_minimum_size = Vector2(0, 60)
	opt_cuerpo.add_theme_font_size_override("font_size", 35)
	p_aspecto.add_child(opt_cuerpo)

	# Botones Guardar y Volver
	var hbox = HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 40)
	vbox_principal.add_child(hbox)

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
	_seleccionar_opcion(opt_cabeza, GameManager.accesorio_cabeza)
	_seleccionar_opcion(opt_cara, GameManager.accesorio_cara)
	_seleccionar_opcion(opt_cuerpo, GameManager.accesorio_cuerpo)

func _seleccionar_opcion(opt: OptionButton, valor: String):
	for i in opt.item_count:
		if opt.get_item_text(i) == valor:
			opt.selected = i
			return

func _on_btn_guardar_pressed():
	GameManager.volumen_musica = slider_musica.value
	GameManager.volumen_efectos = slider_efectos.value
	GameManager.pantalla_fullscreen = checkbox_pantalla.button_pressed
	GameManager.accesorio_cabeza = opt_cabeza.get_item_text(opt_cabeza.selected)
	GameManager.accesorio_cara = opt_cara.get_item_text(opt_cara.selected)
	GameManager.accesorio_cuerpo = opt_cuerpo.get_item_text(opt_cuerpo.selected)
	GameManager.guardar()
	GameManager.aplicar_configuracion()

func _on_btn_volver_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
