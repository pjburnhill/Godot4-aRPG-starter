extends CharacterBody2D

@onready var stats = $Stats

func _ready():
	print('Health_Max: ', stats.max_health)
	print('Health: ', stats.health)

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, delta * 200)
	move_and_slide()

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	print('Health: ', stats.health)
	velocity = area.damage_vector * 120

func _on_stats_no_health():
	call_deferred('free')
