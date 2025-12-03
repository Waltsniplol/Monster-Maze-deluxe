shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform float speed : hint_range(0, 5) = 1.0;
uniform float amplitude : hint_range(0, 50) = 8.0;
uniform float frequency : hint_range(0, 50) = 10.0;

void fragment() {
    vec2 uv = SCREEN_UV;

    // --- efecto de agua / distorsión ---
    float wave = sin((uv.y + TIME * speed) * frequency) * amplitude / 100.0;
    uv.x += wave;

    // --- efecto VHS ---
    vec3 color;
    float r = texture(SCREEN_TEXTURE, uv + vec2(0.003, 0.0)).r;
    float g = texture(SCREEN_TEXTURE, uv).g;
    float b = texture(SCREEN_TEXTURE, uv - vec2(0.003, 0.0)).b;
    color = vec3(r, g, b);

    COLOR = vec4(color, 1.0);
}
