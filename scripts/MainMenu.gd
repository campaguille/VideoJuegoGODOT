extends Control

#Rutas a las escenas
@export var juego: String = "res://scenes/GameScene.tscn"
@export var tutorial: String = "res://scenes/Tutorial.tscn"
@export var personalizar: String = "res://scenes/Customize.tscn"

func _on_btn_jugar_pressed():
	#Cambia la escena a la del juego
	$sonidoClick.play()
	get_tree().change_scene_to_file(juego)

func _on_btn_tutorial_pressed() -> void:
	#Cambia la escena a la del tutorial
	$sonidoClick.play()
	get_tree().change_scene_to_file(tutorial)


func _on_btn_personalizar_pressed() -> void:
	#Cambia la escena a la de personalizar
	$sonidoClick.play()
	get_tree().change_scene_to_file(personalizar)

func _on_btn_salir_pressed() -> void:
	#Cierra el juego completamente
	$sonidoClick.play()
	get_tree().quit()
