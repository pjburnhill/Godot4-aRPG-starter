extends CharacterBody2D

@export var ACCELERATION = 500
@export var MAX_SPEED = 80
@export var ROLL_SPEED = 125
@export var FRICTION = 700
@export var input_vector = Vector2.ZERO

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var roll_vector = Vector2.DOWN
var stats = PlayerStats
const PlayerHurtSound = preload("res://Assets/Player/player_hurt_sound.tscn");


# Assign exported var to Vector2 variable for speed
var VEC_MAX_SPEED = Vector2(MAX_SPEED, MAX_SPEED)

@onready var camera = $FollowCam
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var swordHitbox = $HitboxPivot/SwordHitbox
@onready var hurtbox = $Hurtbox
@onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority(): return
	randomize()
	stats.no_health.connect(player_death)
	animationTree.active = true
	camera.make_current()

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	match state:
		MOVE:
			move_state(delta)
			
		ROLL:
			roll_state()
			
		ATTACK:
			attack_state()

func move_state(delta):
	if not is_multiplayer_authority(): return
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.damage_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * VEC_MAX_SPEED, ACCELERATION * delta)
		#print(velocity)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_slide()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state():
	if not is_multiplayer_authority(): return
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move_and_slide()

func attack_state():
	if not is_multiplayer_authority(): return
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func roll_animation_finished():
	if not is_multiplayer_authority(): return
	velocity = velocity * 0.8
	state = MOVE

func attack_animation_finished():
	if not is_multiplayer_authority(): return
	state = MOVE

func player_death():
	call_deferred('free')

func _on_hurtbox_area_entered(area):
	if not is_multiplayer_authority(): return
	if hurtbox.invincible == false:
		stats.health -= area.damage
		hurtbox.start_invincibility(1)
		hurtbox.create_hit_effect()
		var playerHurtSound = PlayerHurtSound.instantiate()
		get_tree().current_scene.add_child(playerHurtSound)

func _on_hurtbox_invincibility_started():
	if not is_multiplayer_authority(): return
	blinkAnimationPlayer.play("Blink")

func _on_hurtbox_invincibility_ended():
	if not is_multiplayer_authority(): return
	blinkAnimationPlayer.play("RESET")
