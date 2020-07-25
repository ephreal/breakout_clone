extends KinematicBody2D

var speed : int = 275
var velocity : Vector2 = Vector2()

func _physics_process(delta):
	velocity.x = 0
	velocity.y = 0

	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
	if Input.is_action_pressed("move_right"):
		velocity.x += speed

	velocity = move_and_slide(velocity, Vector2.UP)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
