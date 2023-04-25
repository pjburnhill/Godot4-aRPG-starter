extends Control

@onready var heartUIFull = $HeartUIFull
@onready var heartUIEmpty = $HeartUIEmpty

func set_hearts(value):
	heartUIFull.size.x = value * 15
		
func set_max_hearts(value):
	heartUIEmpty.size.x = value * 15

func _ready():
	set_max_hearts(PlayerStats.max_health)
	set_hearts(PlayerStats.health)
	PlayerStats.health_changed.connect(set_hearts.bind())
	PlayerStats.max_health_changed.connect(set_max_hearts.bind())
