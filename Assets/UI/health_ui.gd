extends Control

@onready var label = $Label

var hearts = 5:
	set(value):
		hearts = clamp(value, 0, max_hearts)

var max_hearts = 4:
	set(value):
		max_hearts = max(value, 1)

func set_hearts(value):
	hearts = value;
	if label != null:
		label.text = "HP = " + str(hearts)

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.health_changed.connect(set_hearts.bind())
