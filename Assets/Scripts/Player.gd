extends RigidBody2D

signal ball_location

var speed : int = 325
var velocity : Vector2 = Vector2()

func _physics_process(delta):
	var mouse_position = get_global_mouse_position()
	self.position.x = mouse_position.x


# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("player", true)
	set_physics_process(false)
	
func start():
	set_physics_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Area2D_body_entered(body):
	if body.get_meta("ball"):
		var ball_position = body.global_position.x
		var paddle_position = global_position.x
		emit_signal("ball_location", ball_position, paddle_position)
