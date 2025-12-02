shader_type spatial;

uniform sampler2D SCREEN_TEXTURE;
uniform float pixel_size = 4.0;
uniform float max_distance = 20.0;

void fragment() {
    // Pixelado: redondeamos coordenadas
    vec2 uv = FRAGCOORD.xy / pixel_size;
    uv = floor(uv) * pixel_size / VIEWPORT_SIZE;

    // Tomamos el color de la pantalla
    vec3 col = texture(SCREEN_TEXTURE, uv).rgb;

    // Simular blanco/negro según distancia aproximada
    float depth = length(FRAGCOORD.xyz);
    float gray = step(max_distance / 2.0, depth);

    // Asignar al fragmento
    ALBEDO = vec3(gray);
}
