shader_type canvas_item;

uniform sampler2D gridTexture;
uniform vec2 gridSize;

void fragment() {
	ivec2 pixelUV = ivec2(UV * vec2(gridSize.x));
	COLOR = texelFetch(gridTexture, pixelUV, 0);
}

