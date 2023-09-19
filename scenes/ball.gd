extends RigidBody3D

var mouse_sensitivity = .05
var key_sensitivity = 7.
var jump_power = 1.

@onready var camera = $Target/camera
var speed = 20.0
var running = false
var jumping = false
var steering = false
var wiggle_factor_min = 0.1
var wiggle_factor_max = 3.0
var wiggle_factor = wiggle_factor_min

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Input.is_action_pressed("move_jump")
	if get_contact_count() > 0:
		# On a surface?
		wiggle_factor += 5.0 * delta
		
		if jumping:
			apply_central_impulse(Vector3(0,1,0) * jump_power)
			max_contacts_reported = 0
			$JumpTimeout.start()
	else:
		wiggle_factor *= 1.0 - delta * 0.9

	wiggle_factor = clampf(wiggle_factor, wiggle_factor_min, wiggle_factor_max)

#	if running:
#		apply_central_impulse(camera.basis * Vector3(0, 0, -1) * speed * delta)

	# Increase speed slowly
	speed *= 1 + .01 * delta

	var x = Input.get_axis("move_left", "move_right") * (1.0+linear_velocity.length()) * key_sensitivity * delta
	var y = 0 #Input.get_axis("move_forward", "move_backward") * key_sensitivity * delta
	if !(is_zero_approx(x) and is_zero_approx(y)):
		steer(x, y)

func _input(event):
	jumping = false
	running = true
	if event is InputEventMouseMotion:
		var x = event.relative.x * mouse_sensitivity
		var y = event.relative.y * mouse_sensitivity
		y = 0.0
		steer(x,y)

func steer(x, y):
	apply_torque(camera.basis * Vector3(y, 0, -x * 4) )
	apply_torque(camera.basis * Vector3(-abs(x)*3, 0, 0) )
	if steering:
		apply_central_impulse(camera.basis * Vector3(x, 0.01, -abs(x) * wiggle_factor ))

func _on_jump_timeout():
	max_contacts_reported = 1
