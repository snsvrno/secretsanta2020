package shader;

class SimpleSwapper extends hxsl.Shader {

	static var SRC = {
		var textureColor : Vec4;

		@param var base : Vec3;
		@param var color1 : Vec3;
		@param var color2 : Vec3;
		@param var slider : Float;

		function fragment() {
			var cdiff = textureColor.rgb - base;
			if (cdiff.dot(cdiff) < 0.00001) {
				textureColor.rgb = color1 * (1 - slider) + color2 * slider;
			}
		}

	};

	public function new(base : Int, color1 : Int, ?color2 : Int, ?slider : Float) {
		super();

		this.base.setColor(base);
		this.color1.setColor(color1);

		if (color2 == null) this.color2.setColor(color1);
		else this.color2.setColor(color2);

		if (slider == null) this.slider = 0.0;
		else this.slider = sn.Math.clampf(slider, 0.0, 1.0);
	}
}