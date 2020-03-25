extends Spatial

func _on_Coin1_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed == true and Input.is_action_pressed("highlight") == true:
			print("Found some coins!")
			self.hide()
