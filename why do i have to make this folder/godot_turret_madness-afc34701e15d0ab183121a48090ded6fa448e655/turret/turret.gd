extends StaticBody2D
export var player_position = Vector2(0,0)

signal shoot(initial_position, movement_vector)

const bullet_scene = preload("res://bullets/Bullet.tscn")

var RELOAD_TIME = 2
var pseudo_timer = rand_range(0, RELOAD_TIME)

func _physics_process(delta):
	look_at(player_position)
	
	pseudo_timer += delta
	if pseudo_timer > RELOAD_TIME:
		shoot()
		pseudo_timer -= RELOAD_TIME
	
func shoot():
	emit_signal("shoot", position + Vector2(50, 0).rotated(rotation), Vector2(300, 0).rotated(rotation))
	
