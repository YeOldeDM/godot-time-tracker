
extends Control
tool

var time=0 setget _set_time

const PATH = 'res://addons/work-time/'

var reset_time = 0

func _set_time(value):
	time = value
	get_node('box/Time').set_text(display_time(time))


func save():
	var file = File.new()
	var opened = file.open(PATH+'time.sav', File.WRITE)
	if opened == OK:
		file.store_line({'time': time}.to_json())
	file.close()

func restore():
	var file = File.new()
	var opened = file.open(PATH+'time.sav', File.READ)
	if opened == OK:
		var data = {}
		while !file.eof_reached():
			data.parse_json(file.get_line())
		if data['time'] != null:
			set('time', data['time'])
		else:
			set('time', 0)

func reset():
	set('time', 0)

func _enter_tree():
	restore()
	#get_node('box/Reset').connect('pressed',self,'reset')
	set_process(true)

func _exit_tree():
	save()

func _process(delta):
	if time != null:
		var new_time = time+delta
		set('time',new_time)
	else:
		restore()

	if get_node('box/Reset').is_pressed():
		reset_time += delta
	else:
		reset_time = 0
	if reset_time >= 3.0:
		reset()
		reset_time = 0
		get_node('box/Reset').set_pressed(false)

func display_time(T):
	if T == null:	T=0
	T = int(T)
	var seconds = T % 60
	var minutes = T/60 % 60
	var hours = T/(60*60) % 24
	var days = T/(60*60*24)
	return str(days)+" days\n"+str(hours)+" hours\n"+str(minutes)+" minutes\n"+str(seconds)+" seconds"