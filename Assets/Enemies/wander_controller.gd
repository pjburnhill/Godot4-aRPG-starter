extends Node2D

@export var wonder_range:int = 32

@onready var start_position = global_position
@onready var target_position = global_position
@onready var timer = $Timer

func _ready():
	update_target_postion()

func update_target_postion():
	var target_vector = Vector2(randi_range(-wonder_range, wonder_range), randi_range(-wonder_range, wonder_range))
	target_position = start_position + target_vector

func get_time_left():
	return timer.time_left
	
func start_wander_timer(duration):
	timer.start(duration)

func _on_timer_timeout():
	update_target_postion()
