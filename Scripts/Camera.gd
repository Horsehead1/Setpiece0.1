extends Camera

export var distance = 15.0
export var height = 11.0
export var horizontal = 7.0

func _ready():
	set_physics_process(true)
	
	set_as_toplevel(true)

func _physics_process(_delta):
	var target = get_parent().get_global_transform().origin
	var pos = get_global_transform().origin
	var up = Vector3(0,1,0)
	
	var offset = pos - target
	
	offset = offset.normalized()*distance
	offset.y = height
	offset.x = horizontal
	
	pos = target + offset
	
	look_at_from_position(pos, target, up)
