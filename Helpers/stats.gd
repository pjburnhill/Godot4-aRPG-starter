extends Node

@export var max_health:int = 4:
	set(value):
		max_health = value
		health = min(health, max_health)
		emit_signal("max_health_changed", value)
		
@export var health:int = 4:
	set(value):
		if value <= max_health:
			health = value
			emit_signal("health_changed", health)
			if health <= 0:
				emit_signal("no_health")
	get:
		return health

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func _ready():
	health = max_health
