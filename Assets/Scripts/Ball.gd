extends KinematicBody2D

signal hit_block
signal hit_floor

export var max_player_reflect_angle : int = 60
var max_x = 500
var max_y = -700
var velocity = Vector2(250, -350)
var player_reflection_angle

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		if collision_info.collider.has_meta("block"):
			$BlockHit.play()
			emit_signal("hit_block", collision_info.collider.get_meta("points"))
			collision_info.collider.free()
			velocity = velocity.bounce(collision_info.normal)
		elif collision_info.collider.has_meta("floor"):
			$FloorHit.play()
			velocity = velocity.bounce(collision_info.normal)
			emit_signal("hit_floor")
		elif collision_info.collider.has_meta("player"):
			if player_reflection_angle == 0:
				velocity = velocity.bounce(collision_info.normal)
			else:
				var bounced = velocity.bounce(collision_info.normal)
				var x = bounced.x * bounced.x
				var y = bounced.y * bounced.y
				var mag = sqrt(x + y)
				x = mag * cos(player_reflection_angle)
				y = mag * sin(player_reflection_angle)
				# Ensure that the Y is in the negative direction
				if y > 0:
					y *= -1
				velocity = Vector2(x, y)
			$GeneralHit.play()
		else:
			velocity = velocity.bounce(collision_info.normal)
			$GeneralHit.play()

# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("ball", true)
	hide()
	set_physics_process(false)
	
func start():
	show()
	set_physics_process(true)


func _on_Player_collision(ball_position, paddle_position):
	var player_collision_position = paddle_position - ball_position
	
	# I'm using a scale from -64 to 64 to calculate the angle the ball should
	# reflect off of the paddle
	if player_collision_position > 64:
		player_collision_position = 64
	elif player_collision_position < -64:
		player_collision_position = -64
	
	if player_collision_position > -10 and player_collision_position < 10:
		player_reflection_angle = 0

	else:
		player_reflection_angle = -90 - (player_collision_position/64)
		
