shader_type spatial;
render_mode world_vertex_coords, diffuse_toon, specular_toon, unshaded;

// Wind Settings
uniform float distort_strength = 0.1;
uniform float distort_stretch = 0.4;
uniform float wind_speed = 0.01;
uniform vec3 wind_force = vec3(1, 0, 1);
uniform sampler2D wind_texture: hint_default_black;
uniform float wind_texture_scale = 0.005;

// Colour Settings
uniform sampler2D grass_colour_ramp : source_color;

void vertex() {
	float wind_power = texture(wind_texture, (vec2(TIME * wind_speed) + (NODE_POSITION_WORLD.xz * wind_texture_scale))).r;
	wind_power = (wind_power - 0.5) * 2.0;
	
	vec3 wind_offset = (wind_force * wind_power) * distort_strength;
	wind_offset *= pow(VERTEX.y + 2.0 - NODE_POSITION_WORLD.y, 2.0);
	
	VERTEX += wind_offset - vec3(0, length(wind_offset) * distort_stretch, 0);
}

void fragment() {
	ALBEDO = texture(grass_colour_ramp, vec2(UV.y * 2.0)).rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
