extends CharacterBody2D

@onready var stats = $Stats
@onready var sprite = $AnimatedSprite
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var hurtbox = $Hurtbox
@onready var softCollision = $SoftCollisionComponent
@onready var wanderController = $WanderController
@onready var animationPlayer = $AnimationPlayer

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
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				update_wonder_state()
				
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wonder_state()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= MAX_SPEED * (delta * 1.5):
				update_wonder_state()
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
				
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	
	move_and_slide()

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func update_wonder_state():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(randi_range(1,3))

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = area.damage_vector * KNOCKBACK_VELOCITY
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.3)

func _on_stats_no_health():
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	call_deferred('free')

func _ready():
	sprite.frame = randf_range(0, sprite.sprite_frames.get_frame_count("Fly")-1)
	state = pick_random_state([IDLE, WANDER])

func _on_hurtbox_invincibility_started():
	animationPlayer.play("Blink")

func _on_hurtbox_invincibility_ended():
	animationPlayer.play("RESET")
