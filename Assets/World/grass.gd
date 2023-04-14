extends Node2D

func create_grass_effect():
	var GrassEffect = preload("res://Assets/Effects/grass_effect.tscn")
	var grassEffect = GrassEffect.instantiate()
	var world = get_tree().current_scene
	world.add_child(grassEffect)
	grassEffect.global_position = global_position
	call_deferred('free')

func _on_hurtbox_area_entered(area):
	create_grass_effect()
	call_deferred('free')
