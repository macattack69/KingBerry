extends Camera

var sensitivity = Vector2(0.3, 0.3)
var speed = 20.0
export var mouse_sens = 0.5

onready var camera = get_node("Camera")

func _ready():
	set_process_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Set the camera's initial position and rotation
	set_translation(Vector3(0, 1.5, 0))
	set_rotation(Vector3(deg2rad(10), 0, 0))

func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= mouse_sens * event.relative.x
		camera.rotation.x -= mouse_sens * event.relative.y
		camera.rotation.x = clamp(camera.rotation.x, -90, 90)
#func _input(event):
	#if event is InputEventMouseMotion:
		#rotation_degrees.y -= mouse_sens * event.relative.x
		#camera.rotation_degrees.x -= mouse_sens * event.relative.y
		#camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)

#dont need this, godot has clamp already
##func clamp_rotation():
	#var limit = deg2rad(80)
	#var x_rotation = get_rotation().x
	#x_rotation = clamp(x_rotation, -limit, limit)
	#set_rotation(Vector3(x_rotation, get_rotation().y, 0))

func process(delta):
	var direction = Vector3()
	direction += -transform.basis.z * Input.get_action_strength("move_forward")
	direction += transform.basis.z * Input.get_action_strength("move_backward")
	direction += -transform.basis.x * Input.get_action_strength("move_left")
	direction += transform.basis.x * Input.get_action_strength("move_right")
	direction.y = 0
	direction = direction.normalized()
	
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

	if direction.length() > 0:
		translate(direction * speed * delta)
