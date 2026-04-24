class_name MapPlayer extends CharacterBody2D

@export var move_speed: float = 2.0

@onready var player_body: = %Body
@onready var player_head: = %Head

@onready var ray_down: = %Down
@onready var ray_up: = %Up
@onready var ray_left: = %Left
@onready var ray_right: = %Right

const tile_size: int = 32
const steps: float = 0.5
var is_moving: bool = false
var can_move: bool = true
var input_direction: Vector2

enum Directions {DOWN, UP, LEFT, RIGHT}

var current_direction: Directions

func _ready() -> void:
	add_to_group("player")
	ray_down.add_exception(self)
	ray_up.add_exception(self)
	ray_left.add_exception(self)
	ray_right.add_exception(self)
	pass

func _process(delta: float) -> void:
	if !is_moving:
		if current_direction == Directions.DOWN:
			player_body.play("idle_down")
			player_head.play("idle_down")
		elif current_direction == Directions.UP:
			player_body.play("idle_up")
			player_head.play("idle_up")
		elif current_direction == Directions.RIGHT:
			player_body.play("idle_right")
			player_head.play("idle_right")
		elif current_direction == Directions.LEFT:
			player_body.play("idle_left")
			player_head.play("idle_left")

func _physics_process(delta):
	if !can_move:
		return
		
	handle_movement()
	
	if Input.is_action_just_pressed("action"):
		check_for_event()

func handle_movement():
	input_direction = Vector2.ZERO

	if Input.is_action_pressed("down"):
		current_direction = Directions.DOWN
		if ray_down.is_colliding() and !is_moving:
			player_body.play("idle_down")
			player_head.play("idle_down")
		else:
			if !is_moving:
				player_body.play("walk_down")
				player_head.play("walk_down")
			input_direction = Vector2.DOWN
			move()
	elif Input.is_action_pressed("up"):
		current_direction = Directions.UP
		if ray_up.is_colliding() and !is_moving:
			player_body.play("idle_up")
			player_head.play("idle_up")
		else:
			if !is_moving:
				player_body.play("walk_up")
				player_head.play("walk_up")
			input_direction = Vector2.UP
			move()
	elif Input.is_action_pressed("right"):
		current_direction = Directions.RIGHT
		if ray_right.is_colliding() and !is_moving:
			player_body.play("idle_right")
			player_head.play("idle_right")
		else:
			if !is_moving:
				player_body.play("walk_right")
				player_head.play("walk_right")
			input_direction = Vector2.RIGHT
			move()
	elif Input.is_action_pressed("left"):
		current_direction = Directions.LEFT
		if ray_left.is_colliding() and !is_moving:
			player_body.play("idle_left")
			player_head.play("idle_left")
		else:
			if !is_moving:
				player_body.play("walk_left")
				player_head.play("walk_left")
			input_direction = Vector2.LEFT
			move()
			
func move():
	if input_direction:
		if is_moving == false:
			is_moving = true
			var target_position = position + (input_direction * tile_size * steps)
			var tween = create_tween()
			var duration = 0.2 / move_speed
			
			tween.tween_property(self, "position", target_position, duration)
			tween.tween_callback(change_moving.bind(false))

func change_moving(_moving: bool = false):
	is_moving = _moving

func check_for_event():
	var active_ray: ShapeCast2D = null

	if current_direction == Directions.DOWN:
		active_ray = ray_down
	elif current_direction == Directions.UP:
		active_ray = ray_up
	elif current_direction == Directions.RIGHT:
		active_ray = ray_right
	elif current_direction == Directions.LEFT:
		active_ray = ray_left
			
	if active_ray and active_ray.is_colliding():
		var collider = active_ray.get_collider(0)

		if collider.is_in_group("event"):
			if collider.has_method("fire_event"):
				collider.fire_event()
