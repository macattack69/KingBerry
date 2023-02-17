extends KinematicBody2D

signal hit_player

export var linear_velocity = Vector2(0.0, 0.0)
export var LIFETIME_DURATION = 5
var force_explode_timer = LIFETIME_DURATION

func _physics_process(delta):
	force_explode_timer -= delta
	if force_explode_timer < 0:
		explode()
	
	var collision = move_and_collide(linear_velocity * delta)
	if collision:
		if collision.collider.name == "Player":
			emit_signal("hit_player")
			
		explode()
	
	

func explode():
	queue_free()
