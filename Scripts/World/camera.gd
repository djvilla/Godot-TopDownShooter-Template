extends Camera2D

var MainInstances = ResourceLoader.MainInstances


func _ready():
	MainInstances.WorldCamera = self

func queue_free():
	MainInstances.WorldCamera = null
	.queue_free()
