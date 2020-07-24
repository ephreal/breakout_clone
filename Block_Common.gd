extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _integrate_forces(state): 
	var collision = get_colliding_bodies()
	if len(collision) > 0:
		print(collision)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("block", "block")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



