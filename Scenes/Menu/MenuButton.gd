extends Button

export(PackedScene) var scene_to_load

func _process(_delta):
	if self.disabled:
		focus_mode = Control.FOCUS_NONE
	else:
		focus_mode = Control.FOCUS_ALL
