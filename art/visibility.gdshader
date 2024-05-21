shader_type canvas_item;
render_mode light_only;

void light() {
	if (LIGHT_COLOR.a > 0.0) {
		LIGHT = vec4(LIGHT.rgb, 1.0);
	}
}
