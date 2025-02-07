shader_type spatial;
render_mode unshaded, depth_draw_never;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

const int pixel_size = 3;

void fragment() {
	float x = float(int(FRAGCOORD.x) % pixel_size);
	float y = float(int(FRAGCOORD.y) % pixel_size);

	x = FRAGCOORD.x + floor(float(pixel_size) / 2.0) - x;
	y = FRAGCOORD.y + floor(float(pixel_size) / 2.0) - y;

	ALBEDO = texture(SCREEN_TEXTURE, vec2(x,y)/VIEWPORT_SIZE).xyz;
}

