extends CanvasLayer

@onready var fondo = $TextureRect

func _ready():
	fondo.modulate.a = 0.0

func fade_in(duracion: float = 1.5) -> void:
	fondo.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(fondo, "modulate:a", 1.0, duracion)
	await tween.finished

func fade_out(duracion: float = 0.5) -> void:
	fondo.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(fondo, "modulate:a", 0.0, duracion)
	await tween.finished
