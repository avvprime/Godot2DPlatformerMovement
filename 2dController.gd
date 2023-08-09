extends KinematicBody2D

export var speed = 200
export var acceleration = 0.5
export var friction = 0.2
export var gravity = 50
export var max_fall_speed = 500
export var jump_force = 500

onready var sprite : Sprite = get_node("Sprite")

var velocity : Vector2 = Vector2.ZERO
var on_floor : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	var dir : Vector2 = get_input()
	on_floor = is_on_floor()
	
	velocity.y += gravity
	if velocity.y > max_fall_speed: velocity.y = max_fall_speed
	
	if abs(dir.x) > 0:
		velocity.x = lerp(velocity.x, dir.x * speed, acceleration)
		if dir.x > 0: sprite.flip_h = true
		else: sprite.flip_h = false
		sprite.rotation_degrees = lerp(sprite.rotation_degrees, 3 * -dir.x, 0.5)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
		sprite.rotation_degrees = lerp(sprite.rotation_degrees, 0, 0.5)
	
	if dir.y < 0 && on_floor:
		velocity.y = -jump_force
	
	velocity = move_and_slide(velocity, Vector2.UP)

func get_input() -> Vector2:
	var dir : Vector2 = Vector2.ZERO
	if Input.is_action_pressed("left"): dir.x = -1
	elif Input.is_action_pressed("right"): dir.x = 1
	
	if Input.is_action_just_pressed("jump"): dir.y = -1
	
	return dir
