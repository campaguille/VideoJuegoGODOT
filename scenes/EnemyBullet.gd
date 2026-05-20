extends Area2D

@export var speed: float = 380.0
@export var dano: int = 15
var direction: Vector2 = Vector2.RIGHT

func _ready():
	add_to_group("enemy_bullet")
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(3.0).timeout.connect(queue_free)

func _physics_process(delta):
	global_position += direction.normalized() * speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.recibir_danio(dano)
		queue_free()
