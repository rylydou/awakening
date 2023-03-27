shader_type canvas_item;

uniform float invert_intensity : hint_range(0., 1.) = 0.;
uniform vec4 flash_color : source_color = vec4(1., 1., 1., 0.);

void fragment() {
	// Place fragment code here.
	COLOR.rgb = mix(COLOR.rgb, 1. - COLOR.rgb, invert_intensity);
	COLOR.rgb = mix(COLOR.rgb, flash_color.rgb, COLOR.a*flash_color.a);
}
