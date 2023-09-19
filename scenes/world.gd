extends Node3D

var sections: Array[PackedScene] = [
	preload("res://map/bouncy1.tscn"),
#	preload("res://map/halfpipe1.tscn"),
	preload("res://map/halfpipe2.tscn"),
	preload("res://map/halfpipe3.tscn"),
#	preload("res://map/tube1.tscn"),
	preload("res://map/winding1.tscn"),
	preload("res://map/winding2.tscn"),
	preload("res://map/winding3.tscn"),
	preload("res://map/winding4.tscn"),
	preload("res://map/zigzag1.tscn"),
]

@onready var ball = $Ball
@onready var geometry = $geometry
@onready var camera = $Ball/Target/camera

@onready var next_gate = $StartPlatform/Gate

var N = 0
var max_live_sections = 5

var live_sections: Array[Node3D]

var t_elapsed = 0.0
var distance = 0.0
var last_position: Vector3

func _ready():
	gate_passed()
	ball.steering = true
	unpause()
	%Pause.visible = false
	%GameOver.visible = false
	%HUDTop.visible = true
	%HUDBottom.visible = true
	
	# Ensure start platform gets freed like other sections we've passed
	live_sections.append($StartPlatform)
	
	last_position = ball.global_position

func mps_to_kmph(mps):
	# meters per second to km per hour
	return mps * 60*60 / 1000.

func _physics_process(delta):
	if ball.running:
		t_elapsed += delta
		var d = (ball.global_position-last_position)
		d.y = 0  # Don't count changes in height
		var length = d.length()
		distance += length
		last_position = ball.global_position
		%Time.text = "%.1f" % t_elapsed
		%Distance.text = "%.0f" % distance

		# Only update speeds every 6 frame = 10 times per second
		if get_tree().get_frame() % 6 == 0:
#			print(ball.global_position)
			%AvgSpeed.text = "%.0f" % mps_to_kmph(distance/t_elapsed)
			%Speed.text = "%.0f" % mps_to_kmph(length/delta)

	if ball.global_position.y < -10:
		gameover()

func pause():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func unpause():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func gameover():
	pause()
	%Pause.visible = false
	%GameOver.visible = true
	%HUDTop.visible = true
	%HUDBottom.visible = false
#	pause()

func gate_passed():
#	sections = [
#		preload("res://map/zigzag1.tscn"),
#	]

	# Remove one existing sections
	while len(live_sections) > max_live_sections:
		live_sections.pop_front().queue_free()
		
#	while len(live_sections) <= max_live_sections:
	spawn()

func spawn():
	# Spawn new section
#	N += 1
#	N %= len(sections)
#	N = 3
	N = randi() % len(sections)

	var section: Node3D = sections[N].instantiate()
	print("Adding ", section.scene_file_path)
	geometry.add_child(section)
	live_sections.append(section)

	# Transform so Gate aligns with previous gate (next_gate)
	var gate = section.find_child("Gate")
	section.transform *= next_gate.global_transform
	section.transform *= gate.transform.inverse()

	gate.connect("body_entered", _on_gate_body_entered)

	next_gate = section.find_child("Gate2")
	gate.visible = false
	next_gate.visible = false

func _on_gate_body_entered(body):
	gate_passed()

