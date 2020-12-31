extends Control

var PlayerStats = ResourceLoader.PlayerStats

onready var weaponLabel = $WeaponLabel

func _ready():
	PlayerStats.connect("player_weapon_change", self, "_on_player_weapon_change")

func _on_player_weapon_change(value):
	weaponLabel.text = value
