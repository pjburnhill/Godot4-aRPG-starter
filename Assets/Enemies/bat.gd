extends CharacterBody2D

@onready var stats = $Stats
@onready var sprite = $AnimatedSprite
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var hurtbox = $Hurtbox

const EnemyDeathEffect = preload("res://Assets/Effects/enemy_death_effect.tscn")

@export var ACCELERATION = 250
@export var MAX_SPEED = 20
@export var FRICTION = 50
@export var KNOCKBACK_VELOCITY = 80

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = CHASE

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
		WANDER:
			pass
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = global_position.direction_to(player.global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
				
	move_and_slide()

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = area.damage_vector * KNOCKBACK_VELOCITY
	hurtbox.create_hit_effect()

func _on_stats_no_health():
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	call_deferred('free')

func _ready():
	randomize()
	sprite.frame = randf_range(0, sprite.sprite_frames.get_frame_count("Fly")-1)
