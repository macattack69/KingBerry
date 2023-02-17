extends Node2D

const MARGIN = 80

const TURRET_COUNT = 1
const NEXT_TURRET_DELAY = 10

const turret_scene = preload("res://turret/turret.tscn")
const player_scene = preload("res://player/player.tscn")
const bullet_scene = preload("res://bullets/bullet.tscn")
const health_indicator_scene = preload("res://main/health_indicator.tscn")

var add_turret_pseudo_timer = NEXT_TURRET_DELAY
 
var player

var forbiden_areas = []

func _enter_tree():
	randomize()
	
	for turretIdx in TURRET_COUNT:
		var turret = turret_scene.instance()
		turret.add_to_group("turret")
		turret.connect("shoot", self, "on_shot")
		turret.position = find_position_for_turret(10)
		add_child(turret)
		
	player = player_scene.instance()	
	add_child(player)

	for player_health_indicator_idx in player.max_health:
		var health_indicator = health_indicator_scene.instance()
		health_indicator.name = "health_indicator_%s" % player_health_indicator_idx
		health_indicator.position = Vector2(100 + 50 * player_health_indicator_idx, 50)
		add_child(health_indicator)
		

func _ready():
	player.connect("health_change", self, "on_player_health_changed")
	player.connect("death", self, "on_player_death")

	forbiden_areas.append(Rect2(300, 120, get_viewport_rect().size.x - 600, get_viewport_rect().size.y - 240))


func _physics_process(delta):
	if player:
		for _turret in get_tree().get_nodes_in_group("turret"):
			_turret.player_position = player.position
			
	add_turret_pseudo_timer -= delta		
	if add_turret_pseudo_timer < 0:
		var turret = turret_scene.instance()
		turret.add_to_group("turret")
		turret.connect("shoot", self, "on_shot")
		turret.position = find_position_for_turret(10)
		add_child(turret)
		add_turret_pseudo_timer += NEXT_TURRET_DELAY
		
		
func on_shot(initial_position, movement_vector):
	var bullet = bullet_scene.instance()
	bullet.position = initial_position
	bullet.linear_velocity = movement_vector
	bullet.connect("hit_player", player, "on_hit")
	add_child(bullet)
	
	
func on_player_health_changed():
	for player_health_indicator_idx in player.max_health:
		get_node("health_indicator_%s" % player_health_indicator_idx).frame = 0 if player_health_indicator_idx < player.health else 1

	print("Player health is %s" % player.health)
	

func on_player_death():
	on_player_health_changed()
	print("X_X")

	get_tree().paused = true
	player = null
	
	
func find_position_for_turret(max_attempts):
	var potential_position = null
	for attempt_idx in max_attempts:
			potential_position = Vector2(
				rand_range(MARGIN, get_viewport_rect().size.x - MARGIN),
				rand_range(MARGIN, get_viewport_rect().size.y - MARGIN)
			) 
			var acceptable = true
			for forbiden_area in forbiden_areas:
				if forbiden_area.has_point(potential_position):
					acceptable = false
					break
			
			if acceptable:
				break

	return potential_position
