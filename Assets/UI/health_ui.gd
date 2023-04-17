extends Control

@onready var heartUIFull = $HeartUIFull
@onready var heartUIEmpty = $HeartUIEmpty

var hearts = 4:
	set(value):
		hearts = clamp(value, 0, max_hearts)

var max_hearts = 4:
	set(value):
		max_hearts = max(value, 1)

func set_hearts(value):
	hearts = value;
	print("hearts: ", hearts)
	if heartUIFull != null:
		heartUIFull.size.x = hearts * 15
		
func set_max_hearts(value):
	max_hearts = value
	print("max_hearts: ", max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.size.x = value * 15

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.health_changed.connect(set_hearts.bind())
	PlayerStats.max_health_changed.connect(set_max_hearts.bind())
