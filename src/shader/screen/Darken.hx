package shader.screen;

class Darken extends h3d.shader.ScreenShader {

	static var SRC = {
        @param var texture : Sampler2D;
		@param var intensity : Float;
		@param var color : Vec4;
		
		function fragment() {
			pixelColor = texture.get(input.uv);

			// converts to grayscale using the HDTV Method??
			pixelColor.rgb = pixelColor.rgb * (1 - intensity) + color.rgb * intensity;
		}

	};
}