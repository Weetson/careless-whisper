extends Node3D

var last_rotation = Vector3(0, 0, 0)
var chance_to_spawn : float = 1  # Шанс появления (10%)
var angle_for_spawn : float = 3.14 / 10
var enemy_spawned = false
var enemy
var tween : Tween = null

const ROT_CAMERA_SPEED = 2

@onready var camera = $player/camerapoint/camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var rotation_difference = ($player.global_transform.basis.get_euler() - last_rotation).length()
	last_rotation = $player.global_transform.basis.get_euler()
	#print(rotation_difference)
	
	# Spawn enemy if have right angle
	if rotation_difference > angle_for_spawn and randf() < chance_to_spawn and not enemy_spawned:
		spawn_enemy()
		enemy_spawned = true
		
		#print(enemy.global_transform)
		#print(enemy.global_transform.origin)
		# camera rotation
		lerp_rotate_camera(ROT_CAMERA_SPEED, delta)
		#focus_camera_on(enemy.global_transform.origin)
		
func spawn_enemy():
	# Enemy scene load
	var enemy_scene = preload("res://Scenes/enemygoida.tscn")
	enemy = enemy_scene.instantiate()
	
	# Добавляем врага в ту же сцену, где находится игрок
	get_parent().add_child(enemy)	
		
	# Позиция врага перед игроком
	enemy.global_transform.origin = $player.global_transform.origin + global_transform.basis.z.normalized() * 1	
		
	# Воспроизводим звук врага
	var sound = enemy.get_node("ohlob/sound")

	if sound:
		sound.play()
		sound.connect("finished", Callable(self, "_on_sound_finished"))

func _on_sound_finished():
	enemy_spawned = false
	get_parent().remove_child(enemy)

func focus_camera_on(target_position: Vector3):
	# Создаём Tween динамически, если он ещё не создан
	if not tween or not tween.is_valid():
		tween = create_tween()
	
	var direction = target_position.normalized()
	var new_basis = Basis().looking_at(direction, Vector3.UP)

	# Анимируем вращение камеры через basis
	tween.tween_property(self, "global_transform:basis", new_basis, 0.5)

# fucntion with lerp
func lerp_rotate_camera(speed, delta):
	camera.look_at(enemy.global_transform.origin + Vector3(0, 0.5, 0))
	#camera.global_transform = camera.global_transform.interpolate_with(enemy.global_transform, speed * delta)
