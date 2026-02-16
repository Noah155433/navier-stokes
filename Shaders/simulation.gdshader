shader_type canvas_item;

uniform sampler2D gridTexture;
uniform ivec2 gridSize;

void fragment() {
	ivec2 pixelUV = ivec2(UV * vec2(gridSize));
	COLOR = texelFetch(gridTexture, pixelUV, 0);
}

