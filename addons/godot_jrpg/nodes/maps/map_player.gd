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
	if !GameManager.can_act:
		return
	var dir_string = ""
	match current_direction:
		Directions.DOWN: dir_string = "down"
		Directions.UP: dir_string = "up"
		Directions.LEFT: dir_string = "left"
		Directions.RIGHT: dir_string = "right"
	var is_pressing = Input.get_vector("left", "right", "up", "down") != Vector2.ZERO
	if is_moving or is_pressing:
		player_body.play("walk_" + dir_string)
		player_head.play("walk_" + dir_string)
	else:
		player_body.play("idle_" + dir_string)
		player_head.play("idle_" + dir_string)

func _physics_process(delta: float) -> void:
	if !GameManager.can_act:
		return
	handle_movement()
	if Input.is_action_just_pressed("action"):
		check_for_event()

func handle_movement():
	if !is_moving:
		if Input.is_action_pressed("down"):
			current_direction = Directions.DOWN
			if !ray_down.is_colliding():
				input_direction = Vector2.DOWN
				move()
		elif Input.is_action_pressed("up"):
			current_direction = Directions.UP
			if !ray_up.is_colliding():
				input_direction = Vector2.UP
				move()
		elif Input.is_action_pressed("right"):
			current_direction = Directions.RIGHT
			if !ray_right.is_colliding():
				input_direction = Vector2.RIGHT
				move()
		elif Input.is_action_pressed("left"):
			current_direction = Directions.LEFT
			if !ray_left.is_colliding():
				input_direction = Vector2.LEFT
				move()

func move():
	if input_direction:
		if is_moving == false:
			is_moving = true
			var target_position = position + (input_direction * tile_size * steps)
			var tween = create_tween()
			tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS) 
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
