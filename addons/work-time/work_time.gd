
extends EditorPlugin
tool

const PATH = 'res://addons/work-time/'
var dock

func _enter_tree():
	dock = load(PATH+'WorkTime.tscn').instance()
	
	add_control_to_dock(DOCK_SLOT_LEFT_BR, dock)

func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()
	



