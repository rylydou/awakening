@tool
extends TextureRect

## Use for special actions outside of InputMap. Format is keyboard icon|mouse icon|joypad icon.
const CUSTOM_ACTIONS = {
	"move": "wasd||left_stick"
}

enum {KEYBOARD, MOUSE, JOYPAD}
enum JoypadMode {ADAPTIVE, FORCE_KEYBOARD, FORCE_JOYPAD}
enum FitMode {NONE, MATCH_WIDTH, MATCH_HEIGHT}
enum JoypadModel {AUTO, XBOX, XBOX360, DS3, DS4, DUAL_SENSE, JOY_CON}

const MODEL_MAP = {
	JoypadModel.XBOX: "xbox",
	JoypadModel.XBOX360: "xbox360",
	JoypadModel.DS3: "ds3",
	JoypadModel.DS4: "ds4",
	JoypadModel.DUAL_SENSE: "dual_sense",
	JoypadModel.JOY_CON: "joycon",
}

## Action name from InputMap or CUSTOM_ACTIONS.
@export var action_name: StringName = &"":
	set(action):
		action_name = action
		refresh()

## Whether a joypad button should be used or keyboard/mouse.
@export var joypad_mode: JoypadMode = JoypadMode.ADAPTIVE:
	set(mode):
		joypad_mode = mode
		set_process_input(mode == JoypadMode.ADAPTIVE)
		refresh()

## Controller model for the displayed icon.
@export var joypad_model: JoypadModel = JoypadModel.AUTO:
	set(model):
		joypad_model = model
		if model == JoypadModel.AUTO:
			if not Input.joy_connection_changed.is_connected(on_joy_connection_changed):
				Input.joy_connection_changed.connect(on_joy_connection_changed)
		else:
			if Input.joy_connection_changed.is_connected(on_joy_connection_changed):
				Input.joy_connection_changed.disconnect(on_joy_connection_changed)
		
		_cached_model = ""
		refresh()

## If using keyboard/mouse icon, this makes mouse preferred if available.
@export var favor_mouse: bool = true:
	set(favor):
		favor_mouse = favor
		refresh()

## Use to control the size of icon inside a container.
@export var fit_mode: FitMode = FitMode.MATCH_WIDTH:
	set(mode):
		fit_mode = mode
		refresh()

var _base_path: String
var _use_joypad: bool
var _pending_refresh: bool
var _cached_model: String

func _init():
	add_to_group(&"action_icons")
	texture = load("res://addons/ActionIcon/Keyboard/Blank.png")
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_base_path = get_script().resource_path.get_base_dir()

func _ready() -> void:
	_use_joypad = not Input.get_connected_joypads().is_empty()
	
	if joypad_model == JoypadModel.AUTO:
		Input.joy_connection_changed.connect(on_joy_connection_changed)
	
	set_process_input(joypad_mode == JoypadMode.ADAPTIVE)
	
	if action_name == &"":
		return
	
	assert(InputMap.has_action(action_name) or action_name in CUSTOM_ACTIONS, str("Action \"", action_name, "\" does not exist in the InputMap nor CUSTOM_ACTIONS."))
	
	refresh()

## Forces icon refresh. Useful when you change controls.
func refresh():
	if _pending_refresh:
		return
	
	_pending_refresh = true
	_refresh.call_deferred()

func _refresh():
	if Engine.is_editor_hint() or not is_visible_in_tree():
		return
	
	_pending_refresh = false
	
	if fit_mode != FitMode.NONE:
		custom_minimum_size = Vector2()
	
	if fit_mode == FitMode.MATCH_WIDTH:
		custom_minimum_size.x = size.y
	elif fit_mode == FitMode.MATCH_HEIGHT:
		custom_minimum_size.y = size.x
	
	var is_joypad := false
	if joypad_mode == JoypadMode.FORCE_JOYPAD or (joypad_mode == JoypadMode.ADAPTIVE and _use_joypad):
		is_joypad = true
	
	if action_name in CUSTOM_ACTIONS:
		var image_list: PackedStringArray = CUSTOM_ACTIONS[action_name].split("|")
		assert(image_list.size() >= 3, "Need more |")
		
		if is_joypad and not image_list[JOYPAD].is_empty():
			var model := get_joypad_model(0) + "/"
			texture = get_image(JOYPAD, model + image_list[JOYPAD])
		elif not is_joypad:
			if (favor_mouse or image_list[KEYBOARD].is_empty()) and not image_list[MOUSE].is_empty():
				texture = get_image(MOUSE, image_list[MOUSE])
			elif image_list[KEYBOARD]:
				texture = get_image(KEYBOARD, image_list[KEYBOARD])
		return
	
	var keyboard := ''
	var mouse := -1
	var joypad := -1
	var joypad_axis := -1
	var joypad_axis_value: float
	var joypad_id: int
	
	for event in InputMap.action_get_events(action_name):
		if event is InputEventKey and keyboard.is_empty():
			keyboard = event.as_text_physical_keycode()
		elif event is InputEventMouseButton and mouse == -1:
			mouse = event.button_index
		elif event is InputEventJoypadButton and joypad == -1:
			joypad = event.button_index
			joypad_id = event.device
		elif event is InputEventJoypadMotion and joypad_axis == -1:
			joypad_axis = event.axis
			joypad_axis_value = event.axis_value
			joypad_id = event.device
	
	if is_joypad and joypad >= 0:
		texture = get_joypad(joypad, joypad_id)
	elif is_joypad and joypad_axis >= 0:
		texture = get_joypad_axis(joypad_axis, joypad_axis_value, joypad_id)
	elif not is_joypad:
		if mouse >= 0 and (favor_mouse or keyboard.is_empty()):
			texture = get_mouse(mouse)
		elif not keyboard.is_empty():
			texture = get_image(KEYBOARD, keyboard.to_camel_case())
	
	if not texture and action_name != &"":
		push_error(str("No icon for action: ", action_name))

func get_joypad_model(device: int) -> String:
	if not _cached_model.is_empty():
		return _cached_model
	
	var model := "Xbox"
	if joypad_model == JoypadModel.AUTO:
		var device_name := Input.get_joy_name(maxi(device, 0))
		if device_name.contains("Xbox 360"):
			model = "Xbox360"
		elif device_name.contains("PS3"):
			model = "DS3"
		elif device_name.contains("PS4"):
			model = "DS4"
		elif device_name.contains("PS5"):
			model = "DualSense"
		elif device_name.contains("Joy-Con") or device_name.contains("Joy Con") or device_name.contains('Nintendo'):
			model = "JoyCon"
	else:
		model = MODEL_MAP[joypad_model]
	
	_cached_model = model
	return model

func get_joypad(button: int, device: int) -> Texture:
	var model := get_joypad_model(device) + "/"
	
	match button:
		JOY_BUTTON_A:
			return get_image(JOYPAD, model + "a")
		JOY_BUTTON_B:
			return get_image(JOYPAD, model + "b")
		JOY_BUTTON_X:
			return get_image(JOYPAD, model + "x")
		JOY_BUTTON_Y:
			return get_image(JOYPAD, model + "y")
		JOY_BUTTON_LEFT_SHOULDER:
			return get_image(JOYPAD, model + "lb")
		JOY_BUTTON_RIGHT_SHOULDER:
			return get_image(JOYPAD, model + "rb")
		JOY_BUTTON_LEFT_STICK:
			return get_image(JOYPAD, model + "l")
		JOY_BUTTON_RIGHT_STICK:
			return get_image(JOYPAD, model + "r")
		JOY_BUTTON_GUIDE:
			return get_image(JOYPAD, model + "select")
		JOY_BUTTON_START:
			return get_image(JOYPAD, model + "start")
		JOY_BUTTON_DPAD_UP:
			return get_image(JOYPAD, model + "d_pad_up")
		JOY_BUTTON_DPAD_DOWN:
			return get_image(JOYPAD, model + "d_pad_down")
		JOY_BUTTON_DPAD_LEFT:
			return get_image(JOYPAD, model + "d_pad_left")
		JOY_BUTTON_DPAD_RIGHT:
			return get_image(JOYPAD, model + "d_pad_right")
	return null

func get_joypad_axis(axis: int, value: float, device: int) -> Texture:
	var model := get_joypad_model(device) + "/"
	
	match axis:
		JOY_AXIS_LEFT_X:
			if value < 0:
				return get_image(JOYPAD, model + "left_stick_left")
			elif value > 0:
				return get_image(JOYPAD, model + "left_stick_right")
			else:
				return get_image(JOYPAD, model + "left_stick")
		JOY_AXIS_LEFT_Y:
			if value < 0:
				return get_image(JOYPAD, model + "left_stick_up")
			elif value > 0:
				return get_image(JOYPAD, model + "left_stick_down")
			else:
				return get_image(JOYPAD, model + "left_stick")
		JOY_AXIS_RIGHT_X:
			if value < 0:
				return get_image(JOYPAD, model + "right_stick_left")
			elif value > 0:
				return get_image(JOYPAD, model + "right_stick_right")
			else:
				return get_image(JOYPAD, model + "right_stick")
		JOY_AXIS_RIGHT_Y:
			if value < 0:
				return get_image(JOYPAD, model + "right_stick_up")
			elif value > 0:
				return get_image(JOYPAD, model + "right_stick_down")
			else:
				return get_image(JOYPAD, model + "right_stick")
		JOY_AXIS_TRIGGER_LEFT:
			return get_image(JOYPAD, model + "lt")
		JOY_AXIS_TRIGGER_RIGHT:
			return get_image(JOYPAD, model + "rt")
	return null

func get_mouse(button: int) -> Texture:
	match button:
		MOUSE_BUTTON_LEFT:
			return get_image(MOUSE, "left")
		MOUSE_BUTTON_RIGHT:
			return get_image(MOUSE, "right")
		MOUSE_BUTTON_MIDDLE:
			return get_image(MOUSE, "middle")
		MOUSE_BUTTON_WHEEL_DOWN:
			return get_image(MOUSE, "wheel_down")
		MOUSE_BUTTON_WHEEL_LEFT:
			return get_image(MOUSE, "wheelleft")
		MOUSE_BUTTON_WHEEL_RIGHT:
			return get_image(MOUSE, "wheel_right")
		MOUSE_BUTTON_WHEEL_UP:
			return get_image(MOUSE, "wheel_up")
	return null

func get_image(type: int, image: String) -> Texture2D:
	match type:
		KEYBOARD:
			return load(_base_path + "/keyboard/" + image + ".png") as Texture
		MOUSE:
			return load(_base_path + "/mouse/" + image + ".png") as Texture
		JOYPAD:
			return load(_base_path + "/joypad/" + image + ".png") as Texture
	return null

func on_joy_connection_changed(device: int, connected: bool):
	if connected:
		_cached_model = ""
		refresh()

func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	
	if _use_joypad and (event is InputEventKey or event is InputEventMouseButton or event is InputEventMouseMotion):
		_use_joypad = false
		refresh()
	elif not _use_joypad and (event is InputEventJoypadButton or event is InputEventJoypadMotion):
		_use_joypad = true
		refresh()

func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		if is_visible_in_tree() and _pending_refresh:
			_refresh()
