extends Node3D

var last_rotation = Vector3(0, 0, 0)
var chance_to_spawn : float = 1  # Шанс появления (10%)
var angle_for_spawn : float = 3.14 / 10
var enemy_spawned = false
var enemy
var tween : Tween = null

const DISTANCE_TO_PLAYER = 1.2
const ROT_CAMERA_SPEED = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var rotation_difference = ($player.global_transform.basis.get_euler() - last_rotation).length()
	last_rotation = $player.global_transform.basis.get_euler()
	
	
	# Spawn enemy if have right angle
	if rotation_difference > angle_for_spawn and randf() < chance_to_spawn and not enemy_spawned:
		spawn_enemy()
		enemy_spawned = true
		
		# camera rotation
		lerp_rotate_camera(ROT_CAMERA_SPEED, delta)
		
func spawn_enemy():
	# Enemy scene load
	var enemy_scene = preload("res://Scenes/enemygoida.tscn")
	enemy = enemy_scene.instantiate()
	
	# Добавляем врага в ту же сцену, где находится игрок
	get_parent().add_child(enemy)	
		
	# Позиция врага перед игроком
	enemy.global_transform.origin = $player.global_transform.origin + global_transform.basis.z.normalized() * DISTANCE_TO_PLAYER	
		
	# Воспроизводим звук врага
	var sound = enemy.get_node("ohlob/sound")

	if sound:
		sound.play()
		sound.connect("finished", Callable(self, "_on_sound_finished"))

func _on_sound_finished():
	enemy_spawned = false
	get_parent().remove_child(enemy)

# fucntion with lerp
func lerp_rotate_camera(speed, delta):
	var enemy_position = enemy.global_transform.origin
	var camera_position = $player.global_transform.origin
	var camera_angle = $player.global_transform.basis.get_euler()
	Basis()
	print("enemy_position - ", enemy_position)
	print("camera_position - ", camera_position)
	print("camera_angle - ", camera_angle)
	var diff = enemy_position - camera_position
	print("diff - ", diff)
	var distance = ((diff.x ** 2) + (diff.z ** 2)) ** 0.5
	print("distance - ", distance)
	var sin_dis = diff.z / distance
	var cos_dis = diff.x / distance
	print("sin_dis - ", asin(sin_dis))
	camera_angle = global_transform.basis.get_euler()
	print("camera_angle - ", camera_angle)
