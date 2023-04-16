extends Node2D

const GrassEffect = preload("res://Assets/Effects/grass_effect.tscn")

func create_grass_effect():
	var grassEffect = GrassEffect.instantiate()
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position
	call_deferred('free')

func _on_hurtbox_area_entered(_area):
	create_grass_effect()
	call_deferred('free')
