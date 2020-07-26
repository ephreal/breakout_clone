extends Node2D


var score = 0
var lives = 5
var life_up = 1000
var to_next_life = 1000
var level_load_path = "res://Assets/Level/Level%s.tscn"
var current_level_index = 0
var levels = [1, 2, 3, 4]
var current_level = level_load_path % levels[current_level_index]
var level = load(current_level)
var level_instance = level.instance()
var is_paused = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$UI/ScoreLabel.text = str(score)

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if is_paused:
			unpause()
			is_paused = false
		else:
			pause()
			is_paused = true


func reset_ball():
	$Ball.set_physics_process(false)
	$Ball.hide()
	$Ball.position = $BallStartPosition.position


func next_level():
	current_level_index += 1
	if len(levels) == current_level_index:
		return win()
	reset_ball()
	var x = 250 + (current_level_index * 50)
	var y = -350 + (current_level_index * 50)
	if x > $Ball.max_x:
		x = $Ball.max_x
	if y < $Ball.max_y:
		y = $Ball.max_y
	$Ball.velocity = Vector2(x, y)
	level_instance.queue_free()
	current_level = level_load_path % levels[current_level_index]
	level = load(current_level)
	start_level()
	

func start_level():
	level_instance = level.instance()
	add_child(level_instance)
	show_message("Level %s" % levels[current_level_index])
	$MessageTimer.start()
	yield($MessageTimer, "timeout")
	$UI/Message.hide()
	$Ball.start()
	$Player.start()
	
	
func win():
	reset_ball()
	$MessageTimer.start()
	show_message("You won!")
	yield($MessageTimer, "timeout")
	$UI/Message.hide()
	level_instance.queue_free()
	$UI/Title.show()
	$UI/Message.hide()
	$UI/StartButton.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func game_over():
	reset_ball()
	$MessageTimer.start()
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$UI/Message.hide()
	level_instance.queue_free()
	$UI/Title.show()
	$UI/Message.hide()
	$UI/StartButton.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func update_score(amount):
	score += amount
	$UI/ScoreLabel.text = str(score)
	$UI/LivesLabel.text = str(lives)
	if score > to_next_life:
		to_next_life += life_up
		add_life()

	level_instance.blocks -= 1
	if level_instance.blocks == 0:
		next_level()

func new_game():
	score = 0
	lives = 5
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$UI/ScoreLabel.text = str(score)
	$UI/LivesLabel.text = str(lives)
	$UI/StartButton.hide()
	$UI/Title.hide()
	start_level()
	
func show_message(message):
	$UI/Message.text = str(message)
	$UI/Message.show()


func add_life():
	lives += 1
	$UI/LivesLabel.text = str(lives)
	$LifeUpPlayer.play()
	


func lose_life():
	lives -= 1
	$UI/LivesLabel.text = str(lives)
	$Ball.set_physics_process(false)
	reset_locations()
	if lives == 0:
		return game_over()
	yield($MessageTimer, "timeout")
	$Ball.start()

func reset_locations():
	$Ball.position = $BallStartPosition.position
	if $Ball.velocity.y > 0:
		$Ball.velocity.y *= -1
	$Player.position = $PlayerStartPosition.position
	$MessageTimer.start()
	

func pause():
	show_message("Paused")
	$Ball.set_physics_process(false)
	$Player.set_physics_process(false)
	
func unpause():
	$UI/Message.hide()
	$Ball.set_physics_process(true)
	$Player.set_physics_process(true)
