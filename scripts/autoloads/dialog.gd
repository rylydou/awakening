extends CanvasLayer

var index := -1
var current_text: PackedStringArray

@onready var dialog_text: RichTextLabel = %DialogText
@onready var continue_prompt: Control = %ContinuePrompt
@onready var close_prompt: Control = %ClosePrompt

func _ready() -> void:
	hide()

func say(text: PackedStringArray) -> void:
	Game.pause()
	current_text = text
	index = 0
	show()
	update()

var tween: Tween
func update() -> void:
	if is_instance_valid(tween):
		tween.kill()
	
	if index >= current_text.size():
		index = -1
		hide()
		Game.unpause()
		return
	
	var text := current_text[index]
	dialog_text.text = text
	
	continue_prompt.visible = index < current_text.size() - 1
	close_prompt.visible = not continue_prompt.visible
	
	tween = create_tween()
	tween.tween_property(dialog_text, 'visible_ratio', 1., text.length()*(1/60.)).from(0.)

func _unhandled_input(event: InputEvent) -> void:
	if index < 0: return
	if not event.is_action_pressed('action_a') and not event.is_action_pressed('action_b') and not event.is_action_pressed('action_c'): return
	
	get_viewport().set_input_as_handled()
	
	if dialog_text.visible_ratio < 1:
		if is_instance_valid(tween):
			tween.kill()
		
		dialog_text.visible_ratio = 1
		return
	
	index += 1
	update()
