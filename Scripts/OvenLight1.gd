extends OmniLight

onready var anim = get_node("AnimationPlayer")

func _ready():
	if anim.current_animation != "Oven1":
		anim.play("Oven1")
	else:
		pass
