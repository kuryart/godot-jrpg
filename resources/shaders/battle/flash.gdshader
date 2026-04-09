shader_type canvas_item;

uniform vec4 flash_color: source_color = vec4(1.0f);
uniform float flash_percentage: hint_range(0.0f, 1.0f) = 0.0f;

void fragment() {
	float modulate_alpha = COLOR.a;
	
	vec4 original_color = texture(TEXTURE, UV);
	vec4 mixed_color = mix(original_color, flash_color, flash_percentage);
	
	COLOR = mixed_color;
	COLOR.a = original_color.a * modulate_alpha;
}