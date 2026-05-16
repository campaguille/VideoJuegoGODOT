extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta):
	var Player = get_parent().get_node("Player")
	position += (Player.position - position) / 50
	look_at(Player.position)
	move_and_slide()

func kill():
	queue_free()
