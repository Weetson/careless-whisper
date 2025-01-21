extends Node3D

var last_rotation = Vector3(0, 0, 0)
var chance_to_spawn : float = 1  # Шанс появления (10%)
var angle_for_spawn : float = 3.14 / 10
var enemy_spawned = false
var enemy
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var rotation_difference = ($player.global_transform.basis.get_euler() - last_rotation).length()
	last_rotation = $player.global_transform.basis.get_euler()
	#print(rotation_difference)
	
	if rotation_difference > angle_for_spawn and randf() < chance_to_spawn and not enemy_spawned:
		spawn_enemy()
		enemy_spawned = true
	
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
		print(sound.bus)
		sound.play()
		sound.connect("finished", Callable(self, "_on_sound_finished"))

func _on_sound_finished():
	enemy_spawned = false
	get_parent().remove_child(enemy)
