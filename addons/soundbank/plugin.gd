@tool
extends EditorPlugin

const PLUGIN_NAME := 'SoundBank'
const PLUGIN_PATH := 'res://addons/soundbank/soundbank.gd'

func _enter_tree() -> void:
	add_autoload_singleton(PLUGIN_NAME, PLUGIN_PATH)

func _exit_tree() -> void:
	remove_autoload_singleton(PLUGIN_NAME)
