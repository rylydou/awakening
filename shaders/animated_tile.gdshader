shader_type canvas_item;

uniform int frame_count = 4;
uniform int fps = 5;

void fragment() {
	COLOR = texture(TEXTURE, UV);
}
