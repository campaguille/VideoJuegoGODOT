extends Area2D

@export var speed: float = 700.0
@export var dano: int = 10
var direction: Vector2 = Vector2.RIGHT

func _ready():
	add_to_group("bullet")
	body_entered.connect(_on_body_entered)
	# Se destruye sola al salir de pantalla via VisibleOnScreenNotifier2D
	# o por tiempo:
	get_tree().create_timer(2.5).timeout.connect(queue_free)

func _physics_process(delta):
	global_position += direction.normalized() * speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		return
	if body.has_method("recibir_danio"):
		body.recibir_danio(dano)
	queue_free()
