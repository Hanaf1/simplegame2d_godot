extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var SPEED = 100
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player 
var chase = false

func _ready():
	get_node("AnimatedSprite2D").play("Idle")
	
func _physics_process(delta):
	velocity.y += gravity * delta
	if chase == true :
		if get_node("AnimatedSprite2D").animation != "Death": 
			get_node("AnimatedSprite2D").play("Jump")
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0 :
			get_node("AnimatedSprite2D").flip_h = true
		else :
			get_node("AnimatedSprite2D").flip_h = false
		velocity.x = direction.x * SPEED
	else:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Idle")
		velocity.x = 0
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name ==  "Player":
		chase = true
	
func _on_player_detection_body_exited(body):
	if body.name ==  "Player":
		chase = false

func _on_player_death_body_entered(body):
	if body.name == "Player":
		death()
		
func _on_player_collison_body_entered(body):
	if body.name == "Player":
		Game.playerHP -= 3
		death()
		
func death():
	Game.Gold += 5
	Utils.saveGame()
	chase = false
	var animated_sprite = get_node("AnimatedSprite2D")
	animated_sprite.play("Death")
	animated_sprite.connect("animation_finished", Callable(self, "_on_death_animation_finished"))
	
func _on_death_animation_finished():
	self.queue_free()
	
