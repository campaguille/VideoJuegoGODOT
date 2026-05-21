extends CanvasLayer

@onready var color = $ColorRect

func _ready():
	color.modulate.a = 0.0

func fade_in(duracion: float = 1.5) -> void:
	color.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(color, "modulate:a", 1.0, duracion)
	await tween.finished

func fade_out(duracion: float = 0.5) -> void:
	color.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(color, "modulate:a", 0.0, duracion)
	await tween.finished
