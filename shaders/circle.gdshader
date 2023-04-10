shader_type canvas_item;

uniform float size_px = 64.;
uniform float radius_ratio: hint_range(0.0, 1.0) = 1.;
uniform float border_px = 1;

void fragment() {
	const vec2 CENTER_UV = vec2(.5, .5);
	
	float f = 1./size_px;
	f = 0.001;
	float l = length(UV - CENTER_UV);
	float b = border_px/size_px;
	float r = radius_ratio;
	float a = smoothstep(f, 0., abs(l - r*.5 + b*.25 + f) - b*.25);   
	//float a = step(l, .5);   
	
	COLOR.a *= a;
}
