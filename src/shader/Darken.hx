package shader;

/**
 * Creates a shader that overlays a color on top of the image
 * at a given intensity. defaults to using white.
 */
class Darken extends shader.Highlight {

	public function new(intensity : Float, ?color : Int = 0x000000) super(intensity, color);
}