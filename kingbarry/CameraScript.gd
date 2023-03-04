extends Camera

var sensitivity = Vector2(0.3, 0.3)
var speed = 20.0

func _ready():
	set_process_input(true)

	# Set the camera's initial position and rotation
	set_translation(Vector3(0, 1.5, 0))
	set_rotation(Vector3(deg2rad(10), 0, 0))

func _input(event):
	if event is InputEventMouseMotion:
		rotate_x(deg2rad(-event.relative.y * sensitivity.y))
		rotate_y(deg2rad(-event.relative.x * sensitivity.x))
		clamp_rotation()

func clamp_rotation():
	var limit = deg2rad(80)
	var x_rotation = get_rotation().x
	x_rotation = clamp(x_rotation, -limit, limit)
	set_rotation(Vector3(x_rotation, get_rotation().y, 0))

func process(delta):
	var direction = Vector3()
	direction += -transform.basis.z * Input.get_action_strength("move_forward")
	direction += transform.basis.z * Input.get_action_strength("move_backward")
	direction += -transform.basis.x * Input.get_action_strength("move_left")
	direction += transform.basis.x * Input.get_action_strength("move_right")
	direction.y = 0
	direction = direction.normalized()

	if direction.length() > 0:
		translate(direction * speed * delta)
