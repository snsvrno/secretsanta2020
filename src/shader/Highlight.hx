package shader;

/**
 * Creates a shader that overlays a color on top of the image
 * at a given intensity. defaults to using white.
 */
class Highlight extends hxsl.Shader {

	static var SRC = {
		var textureColor : Vec4;

		@param var intensity : Float;
		@param var color : Vec3;

		function fragment() {
			textureColor.rgb = textureColor.rgb * (1-intensity) + color.rgb * intensity;
		}

	};

	public function new(intensity : Float, ?color : Int = 0xFFFFFF) {
		super();

		this.intensity = sn.Math.clampf(intensity, 0.0, 1.0);
		this.color.setColor(color); 
	}
}