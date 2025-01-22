extends CharacterBody3D


const SPEED = 5
const JUMP_VELOCITY = 4.5
const CAMERA_ROTATION_SPEED = 0.005
const positive_acceleration = 0.3 # ускорение в начале движения
const negative_acceleration = 0.5 # замедления после отпускания клавиши движения
# vars for camera
var rot = {"y": 0,
			"x" : 0}

# Camera capture
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	
	# Quit
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	print("direction: ", direction)
	if direction:
		var final_speed :=  direction * SPEED
		var normalized_acceleration := (direction * (SPEED-1))/((SPEED - 1)/positive_acceleration/2)
		velocity.x = move_toward(velocity.x, final_speed.x, abs(normalized_acceleration.x))
		velocity.z = move_toward(velocity.z, final_speed.z, abs(normalized_acceleration.z))
		print("velocity after: ", velocity)
		
	else:
		velocity.x = move_toward(velocity.x, 0, negative_acceleration)
		velocity.z = move_toward(velocity.z, 0, negative_acceleration)

	move_and_slide()

# Camera movement
func _input(event):
	if event is InputEventMouseMotion:
		rot["y"] -= event.relative.x * CAMERA_ROTATION_SPEED
		rot["x"] -= event.relative.y * CAMERA_ROTATION_SPEED
		
		# Check for camera dont look too far
		if rot["x"] < -1 : rot["x"] = -1
		if rot["x"] > 1 : rot["x"] = 1
		
		transform.basis = Basis(Vector3(0, 1, 0), rot["y"])
		$camerapoint.transform.basis = Basis(Vector3(1, 0, 0), rot["x"])
