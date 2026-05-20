extends CharacterBody2D

@export var speed: float = 120.0
@export var dano: int = 10
@export var vida: int = 30
@export var puntos_al_morir: int = 50
@export var angle: float = 120.0
@export var angle_length: float = 350.0
@export var distancia_ataque: float = 55.0
@export var cooldown_dano: float = 1.0

@onready var nav   = $NavigationAgent2D
@onready var ray   = $RayCast2D
@onready var anim  = $AnimatedSprite2D
@onready var timer = $TimerTarget

var player = null
var player_target: bool = false
var puede_dañar: bool = true
var posicion_inicial: Vector2
var rotacion_inicial: float
var angle_rad: float

func _ready():
	add_to_group("enemy")
	player           = get_tree().get_first_node_in_group("player")
	angle_rad        = deg_to_rad(angle / 2.0)
	posicion_inicial = global_position
	rotacion_inicial = global_rotation
	await get_tree().physics_frame

func _physics_process(_delta):
	if player == null: return

	if not player_target:
		if _en_cono() and _raycast_ok():
			player_target = true
			timer.start()
		else:
			_volver_origen()
			return

	var dist = global_position.distance_to(player.global_position)

	if dist <= distancia_ataque:
		# Está en contacto: detiene navegación, aplica daño, no empuja
		velocity = Vector2.ZERO
		_intentar_dañar()
		move_and_slide()
	else:
		nav.target_position = player.global_position
		var next = nav.get_next_path_position()
		velocity = (next - global_position).normalized() * speed
		move_and_slide()

		# Detecta colisión física directa con el player por si acaso
		for i in get_slide_collision_count():
			var col = get_slide_collision(i)
			if col.get_collider() == player:
				_intentar_dañar()

	if velocity.length() > 5:
		anim.play("default")
	else:
		anim.stop()

func _volver_origen():
	if global_position.distance_to(posicion_inicial) > 5.0:
		nav.target_position = posicion_inicial
		velocity = (nav.get_next_path_position() - global_position).normalized() * speed
		move_and_slide()
		anim.play("default")
	else:
		global_position = posicion_inicial
		global_rotation = rotacion_inicial
		velocity        = Vector2.ZERO
		anim.stop()

func _en_cono() -> bool:
	var local = to_local(player.global_position)
	return abs(Vector2.RIGHT.angle_to(local)) <= angle_rad and local.length() < angle_length

func _raycast_ok() -> bool:
	ray.target_position = to_local(player.global_position)
	ray.force_raycast_update()
	return ray.get_collider() == player

func _intentar_dañar():
	if not puede_dañar: return
	puede_dañar = false
	if player.has_method("recibir_danio"):
		player.recibir_danio(dano)
	get_tree().create_timer(cooldown_dano).timeout.connect(func(): puede_dañar = true)

func recibir_danio(cantidad: int):
	vida -= cantidad
	if vida <= 0:
		kill()

func kill():
	if player: player.add_score(puntos_al_morir)
	queue_free()

func _on_timer_target_timeout():
	if not (_en_cono() and _raycast_ok()):
		player_target = false
