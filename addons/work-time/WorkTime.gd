extends Control
tool


var session_time=0 setget _set_session_time
var time=0 setget _set_time
var _editor_interface:EditorInterface

const PATH = 'res://addons/work-time/'

var reset_time = 0
var focuse_active = true


func _set_time(value):
	time = value
	get_node('box/total/Time').set_text(display_time(time))

func _set_session_time(value):
	session_time = value
	get_node('box/session/Time').set_text(display_time(session_time,true))

func save():
	var file = File.new()
	var opened = file.open(PATH+'time.txt', File.WRITE)
	if opened == OK:
		file.store_line(JSON.print({'time': time}))
	file.close()

func restore():
	var file = File.new()
	var opened = file.open(PATH+'time.txt', File.READ)
	if opened == OK:
		var data = {}
		while !file.eof_reached():
			var l = file.get_line()
			if !l:
				continue
				
			data = JSON.parse(l).result
		
		if data['time'] != null:
			set('time', data['time'])
		else:
			set('time', 0)
	set('session_time', 0)
		
func reset():
	set('time', 0)


func _enter_tree():
	restore()
	set_process(true)

func _exit_tree():
	save()

func _notification(what):
	
		
	if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		focuse_active = true
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		focuse_active = false


func _process(delta):
	
		
		
	if (OS.is_window_minimized()):
		return
	
	if (!focuse_active):
		if (_editor_interface != null and _editor_interface.get_playing_scene() == ""):
			return
		
	
	if time != null:
		var new_time = time+delta
		set('time',new_time)
	else:
		restore()
	var new_session_time = session_time+delta
	set('session_time', new_session_time)
	

	if get_node('box/total/Reset').is_pressed():
		reset_time += delta
	else:
		reset_time = 0
	if reset_time >= 3.0:
		reset()
		reset_time = 0
		get_node('box/total/Reset').set_pressed(false)

func display_time(T, short=false):
	if T == null:	T=0
	T = int(T)
	var seconds = T % 60
	var minutes = T/60 % 60
	var hours = T/(60*60) % 24
	var days = T/(60*60*24)
	if short:
		return str(hours)+"h, "+str(minutes)+"m, "+str(seconds)+"s"
	else:
		return str(days)+" days\n"+str(hours)+" hours\n"+str(minutes)+" minutes\n"+str(seconds)+" seconds"




