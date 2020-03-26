extends Control

onready var timer = get_node("Menu/LeftSide/Buttons/button_title_quit/Timer")

var scene_path_to_load

func _ready():
	if $Menu/LeftSide/Buttons/button_title_continue.disabled == false:
		$Menu/LeftSide/Buttons/button_title_continue.grab_focus()
	else:
		$Menu/LeftSide/Buttons/button_title_newgame.grab_focus()
	for button in $Menu/LeftSide/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])

func _on_button_title_quit_pressed():
	$FadeIn.show()
	$FadeIn.fade_in()
	timer.start()

func _on_button_title_settings_pressed():
	get_tree().change_scene("res://Scenes/Menu/Settings.tscn")

func _on_Button_pressed(scene_to_load):
#	get_tree().change_scene(scene_to_load)
	scene_path_to_load = scene_to_load
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_Timer_timeout():
	get_tree().quit()

func _on_FadeIn_fade_finished():
	get_tree().change_scene_to(scene_path_to_load)
