extends Camera3D

var last_rotation : Vector3 = Vector3.ZERO
var chance_to_spawn : float = 0.1  # Шанс появления (10%)
var tween : Tween = null
var enemy_spawned = false

func _process(delta):
	var rotation_difference = (global_transform.basis.get_euler() - last_rotation).length()
	if rotation_difference > 3.14 / 6:  # Проверяем поворот на 30 градусов
		last_rotation = global_transform.basis.get_euler()
		if randf() < chance_to_spawn and not enemy_spawned:
			#spawn_enemy()
			enemy_spawned = true

func spawn_enemy():
	# Enemy scene load
	var enemy_scene = preload("res://Scenes/enemygoida.tscn")
	var enemy = enemy_scene.instantiate()
	
	# Добавляем врага в ту же сцену, где находится игрок
	get_parent().add_child(enemy)

	# Позиция врага перед игроком
	enemy.global_transform.origin = global_transform.origin + global_transform.basis.z.normalized() * 1

	# Воспроизводим звук врага
	var sound = enemy.get_node("ohlob/sound")
	if sound:
		sound.play()

	# Поворот камеры к врагу
	focus_camera_on(enemy.global_transform.origin)

func focus_camera_on(target_position: Vector3):
	# Создаём Tween динамически, если он ещё не создан
	if not tween or not tween.is_valid():
		tween = create_tween()
	
	var direction = (target_position - global_transform.origin).normalized()
	var new_basis = Basis().looking_at(direction, Vector3.UP)

	# Анимируем вращение камеры через basis
	tween.tween_property(self, "global_transform:basis", new_basis, 0.5)
