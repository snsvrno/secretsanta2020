package shader;

/**
 * Creates a shader that overlays a color on top of the image
 * at a given intensity. defaults to using white.
 */
class Wipe extends hxsl.Shader {

	static var SRC = {
        @:import h3d.shader.Base2d;

		@param var progress : Float;

		function fragment() {
			if ((calculatedUV.x + (1-calculatedUV.y)) >= 2 * (1-progress)) textureColor.a = 0;
		}

	};

	public function new(progress : Float = 0.0) {
		super();

		this.progress = progress;
	}
}