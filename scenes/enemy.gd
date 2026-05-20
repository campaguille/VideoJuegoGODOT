extends CharacterBody2D

@export var speed: float = 120.0
@export var dano: int = 10
@export var vida: int = 30
@export var puntos_al_morir: int = 50
@export var angle: float = 120.0
@export var angle_length: float = 350.0
@export var distancia_ataque: float = 55.0
@export var cooldown_dano: float = 1.0

@onready var nav   = get_node_or_null("NavigationAgent2D")
@onready var ray   = get_node_or_null("RayCast2D")
@onready var anim  = get_node_or_null("AnimatedSprite2D")
@onready var timer = get_node_or_null("TimerTarget")

var player = null
var player_target: bool = false
var puede_dañar: bool = true
var posicion_inicial: Vector2
var rotacion_inicial: float
var angle_rad: float

var esta_quieto_atacando: bool = false

func _ready():
	# Forzamos que se registre en el grupo al nacer por si falla el editor
	if not is_in_group("enemy"):
		add_to_group("enemy")
		
	player           = get_tree().get_first_node_in_group("player")
	angle_rad        = deg_to_rad(angle / 2.0)
	posicion_inicial = global_position
	rotacion_inicial = global_rotation

	if timer:
		if not timer.timeout.is_connected(_on_timer_target_timeout):
			timer.timeout.connect(_on_timer_target_timeout)

	await get_tree().physics_frame

func _physics_process(_delta):
	if player == null: return

	if esta_quieto_atacando:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		if col.get_collider() == player:
			_intentar_dañar()
			return

	if not player_target:
		if _en_cono() and _raycast_ok():
			player_target = true
			if timer:
				timer.start()
		else:
			_volver_origen()
			return

	var dist = global_position.distance_to(player.global_position)

	if dist <= distancia_ataque:
		velocity = Vector2.ZERO
		_intentar_dañar()
		move_and_slide()
	else:
		if nav:
			nav.target_position = player.global_position
			var next = nav.get_next_path_position()
			velocity = (next - global_position).normalized() * speed
			move_and_slide()

	if velocity.length() > 5:
		if anim and anim.sprite_frames and anim.sprite_frames.has_animation("default"):
			anim.play("default")
	else:
		if anim:
			anim.stop()

func _volver_origen():
	if global_position.distance_to(posicion_inicial) > 5.0:
		if nav:
			nav.target_position = posicion_inicial
			velocity = (nav.get_next_path_position() - global_position).normalized() * speed
			move_and_slide()
			if anim and anim.sprite_frames and anim.sprite_frames.has_animation("default"):
				anim.play("default")
	else:
		global_position = posicion_inicial
		global_rotation = rotacion_inicial
		velocity        = Vector2.ZERO
		if anim:
			anim.stop()

func _en_cono() -> bool:
	var local = to_local(player.global_position)
	return abs(Vector2.RIGHT.angle_to(local)) <= angle_rad and local.length() < angle_length

func _raycast_ok() -> bool:
	if not ray:
		return true
	ray.target_position = to_local(player.global_position)
	ray.force_raycast_update()
	return ray.get_collider() == player

func _intentar_dañar():
	if not puede_dañar: return
	if not is_inside_tree(): return

	puede_dañar = false

	if is_instance_valid(player) and player.has_method("recibir_danio"):
		player.recibir_danio(dano)

	esta_quieto_atacando = true
	velocity = Vector2.ZERO

	var tree = get_tree()
	if tree:
		await tree.create_timer(0.6).timeout
		esta_quieto_atacando = false

		if is_inside_tree() and get_tree():
			get_tree().create_timer(cooldown_dano).timeout.connect(func(): puede_dañar = true)
	else:
		esta_quieto_atacando = false
		puede_dañar = true

func recibir_danio(cantidad: int):
	vida -= cantidad
	if vida <= 0:
		kill()

func kill():
	if is_instance_valid(player) and player.has_method("add_score"):
		player.add_score(puntos_al_morir)

	# CORRECCIÓN CRÍTICA: Lo sacamos del grupo antes de destruirlo 
	# para que el conteo baje a 0 instantáneamente
	if is_in_group("enemy"):
		remove_from_group("enemy")

	queue_free()

	if GameManager and GameManager.has_method("verificar_enemigos_vivos"):
		GameManager.verificar_enemigos_vivos()

func _on_timer_target_timeout():
	if not (_en_cono() and _raycast_ok()):
		player_target = false
