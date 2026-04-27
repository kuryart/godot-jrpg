shader_type canvas_item;

uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.5);
uniform float skew_x = 0.4;
uniform float scale_y = 0.5;

void vertex() {
	// Achata a geometria de CADA tile individualmente (o grid se mantém intacto)
	VERTEX.y *= scale_y;
	
	// Aplica o skew: inclina o tile movendo o X com base no Y
	VERTEX.x += VERTEX.y * skew_x; 
}

void fragment() {
	// Pega a textura original (com os detalhes das folhas/galhos)
	vec4 tex_color = texture(TEXTURE, UV);
	
	// Pinta tudo com a cor da sombra, mas preserva a transparência (recorte) original
	COLOR = vec4(shadow_color.rgb, tex_color.a * shadow_color.a);
}