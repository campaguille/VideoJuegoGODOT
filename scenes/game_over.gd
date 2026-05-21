extends Control

@onready var sfx_game_over = $sfx_gameover
@onready var puntos_label = $puntos

func _ready():
	sfx_game_over.play()
	puntos_label.text = "PUNTOS CONSEGUIDOS: " + str(GameManager.puntos_finales)
	$VBoxContainer/btn_reiniciar.pressed.connect(_on_reiniciar)
	$VBoxContainer/Btn_menu.pressed.connect(_on_menu)

func _on_reiniciar():
	GameManager.puntos_finales = 0
	get_tree().change_scene_to_file("res://scenes/GameScene.tscn")

func _on_menu():
	GameManager.puntos_finales = 0
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
