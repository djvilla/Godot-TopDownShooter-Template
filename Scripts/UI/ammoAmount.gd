extends Control

var PlayerStats = ResourceLoader.PlayerStats

onready var weaponLabel = $AmmoLabel

func _ready():
	PlayerStats.connect("player_ammo_change", self, "_on_player_ammo_change")

func _on_player_ammo_change(mag_ammo, overall_ammo):
	var labelText = str(mag_ammo) + "/" + str(overall_ammo)
	weaponLabel.text = labelText
