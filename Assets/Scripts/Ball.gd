extends KinematicBody2D

signal hit_block
signal hit_floor

var speed = 200
var velocity = Vector2(200, -300)

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.normal)
		if collision_info.collider.has_meta("block"):
			$BlockHit.play()
			emit_signal("hit_block", collision_info.collider.get_meta("points"))
			collision_info.collider.free()
		elif collision_info.collider.has_meta("floor"):
			$FloorHit.play()
			emit_signal("hit_floor")
		else:
			$GeneralHit.play()

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	set_physics_process(false)
	
func start():
	show()
	set_physics_process(true)
