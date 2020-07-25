extends RigidBody2D

export var points : int = 10


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("block", "block")
	set_meta("points", points)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
