extends Button

func _ready():
	pass
	

func _on_button_title_newgame_pressed():
	get_tree().change_scene("res://Scenes/Global/room1.tscn")
