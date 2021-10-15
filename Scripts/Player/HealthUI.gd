extends Control

var HP = 10 setget set_HP
var max_HP = 10 setget set_max_HP

onready var healthBar = $TextureProgress

func set_HP(value):
	HP = clamp(value, 0, max_HP)
	if healthBar.value != null:
		healthBar.value = HP

func set_max_HP(value):
	max_HP = max(value, 1)
	self.HP = min(HP, max_HP)
	if healthBar.max_value != null:
		healthBar.max_value = max_HP


func _ready():
	self.max_HP = PlayerStats.max_health
	self.HP = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_HP")
	PlayerStats.connect("max_health_changed", self, "set_max_HP")
	
