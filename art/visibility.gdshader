shader_type canvas_item;
render_mode light_only;


void light() {
	if (!LIGHT_IS_DIRECTIONAL) {
		LIGHT = COLOR;
	}
}
