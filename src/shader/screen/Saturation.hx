package shader.screen;

class Saturation extends h3d.shader.ScreenShader {

	static var SRC = {
        @param var texture : Sampler2D;
		@param var intensity : Float;
		
		var gray : Vec4;

		function fragment() {
			pixelColor = texture.get(input.uv);

			// converts to grayscale using the HDTV Method??
			gray.r = gray.g = gray.b = pixelColor.r * 0.21 + pixelColor.g * 0.72 + pixelColor.b * 0.07;
			pixelColor.rgb = pixelColor.rgb * (1-intensity) + gray.rgb * intensity;
		}

	};
}