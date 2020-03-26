extends Control

onready var buttoncontrols = get_node("Menu/LeftSide/ControlsMain")
onready var buttoncontrolsbuttons = get_node("Menu/LeftSide/ControlsButtons")
onready var leftside1 = get_node("Menu/LeftSide/Buttons/button_title_general")
onready var leftside2 = get_node("Menu/LeftSide/Buttons/button_title_audio")
onready var leftside3 = get_node("Menu/LeftSide/Buttons/button_title_graphics")
onready var leftside4 = get_node("Menu/LeftSide/Buttons/button_title_controls")
onready var leftside5 = get_node("Menu/LeftSide/Buttons/button_title_back")
onready var buttonscript = load("res://Scenes/Menu/KeyBinding.gd")

var controlsscreen = false

var keybinds
var keys = {}

func _on_button_title_controls_pressed():
	controlsscreen = true
	if controlsscreen:
		buttoncontrols.show()
		buttoncontrolsbuttons.show()
		leftside1.focus_mode = Control.FOCUS_NONE
		leftside2.focus_mode = Control.FOCUS_NONE
		leftside3.focus_mode = Control.FOCUS_NONE
		leftside4.focus_mode = Control.FOCUS_NONE
		leftside5.focus_mode = Control.FOCUS_NONE

func _ready():
	buttoncontrols.hide()
	buttoncontrolsbuttons.hide()
	leftside4.grab_focus()
	
	keybinds = Global.keybinds.duplicate()
	for key in keybinds.keys():
		var hbox = HBoxContainer.new()
		var label = Label.new()
		var button = Button.new()
		
		hbox.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		button.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		
		label.text = key
		
		var button_value = keybinds[key]
		
		if button_value != null:
			button.text = OS.get_scancode_string(button_value)
		else:
			button.text = "Unassigned"
		
		button.set_script(buttonscript)
		button.key = key
		button.value = button_value
		button.settings = self
		button.toggle_mode = true
		button.focus_mode = Control.FOCUS_NONE
		
		hbox.add_child(label)
		hbox.add_child(button)
		buttoncontrols.add_child(hbox)
		
		keys[key] = button

func _process(_delta):
	if leftside4.pressed == false:
		buttoncontrols.hide()
		buttoncontrolsbuttons.hide()

func change_bind(key, value):
	keybinds[key] = value
	for k in keybinds.keys():
		if k != key and value != null and keybinds[k] == value:
			keybinds[k] = null
			keys[k].value = null
			keys[k].text = "Unassigned"

func _on_controlsrestore_pressed():
	queue_free()

func _on_controlsaccept_pressed():
	Global.keybinds = keybinds.duplicate()
	Global.set_game_binds()
	Global.write_config()
