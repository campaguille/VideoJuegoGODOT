extends CharacterBody2D

@export var speed = 400            # Velocidad de movimiento
@export var dash_distance = 400   # Distancia en píxeles que recorrerá el dash
@export var dash_duration = 0.1   # Cuánto tarda en recorrer esa distancia
@export var dash_cooldown = 0.6    # tiempop de espera entre dashes


var bullet = preload("res://bullet.tscn")
var screen_size
var can_dash = true

# Al cargar el juego se redimesiona el tamaño de pantalla
func _ready():
	screen_size = get_viewport_rect().size

# Cada frame se ejecuta este metodo
func _process(delta):
	
	# Creamos un vector combinando los ejes horizontal y vertical.
	var input_dir = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	
	# Si el personaje se esta moviendo 
	if input_dir != Vector2.ZERO:
		# La velocidad sera la direcion multiplicada por la speed
		velocity = input_dir * speed
	else:
		# Si no frena al personaje suavemente hasta llegar a 0
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
	
	#
	look_at(get_global_mouse_position())
	move_and_slide()
	
	# Al pulsar al boton atacar (click izquierdo) 
	if Input.is_action_just_pressed("attack"):
		fire()
		
	# 3. Al pulsar al boton de dash (espacio)
	if Input.is_action_just_pressed("dash") and can_dash:
		# Calculamos la dirección antes de mandarla al método
		var dash_dir = input_dir if input_dir != Vector2.ZERO else Vector2.RIGHT.rotated(rotation)
		dash(dash_dir) # Le pasamos la dirección al método
	

func fire():
	var offset = 30
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = global_position + Vector2.RIGHT.rotated(rotation) * offset
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.direction = Vector2.RIGHT.rotated(rotation)
	get_tree().get_root().add_child(bullet_instance)


func dash(target_direction: Vector2):
	can_dash = false
	
	# Desactivamos las colisiones con enemigos/obstáculos temporalmente 
	$Area2D.monitoring = false

	

	# Creamos un Tween que moverá la POSICIÓN directamente
	var tween = create_tween()
	
	# Calculamos el punto exacto del mapa a donde queremos llegar
	var target_position = global_position + (target_direction * dash_distance)
	
	# Le decimos al tween: "Mueve mi propiedad 'global_position' hacia 'target_position' en 'dash_duration' segundos"
	tween.tween_property(self, "global_position", target_position, dash_duration)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	
	# Esperamos a que el Tween termine de mover al personaje
	await tween.finished
	
	# Volvemos a activar colisiones cuando termina el dash
	$Area2D.monitoring = true

	

	# Esperamos el tiempo de recarga
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true

func kill():
	get_tree().reload_current_scene()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if "enemy" in body.name:
		kill()
