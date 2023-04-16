extends AnimatedSprite2D

func _ready():
	if (!self.animation_finished.is_connected(_on_animation_finished)):
		self.animation_finished.connect(_on_animation_finished)
	play("Animate")

func _on_animation_finished():
	call_deferred('free')
