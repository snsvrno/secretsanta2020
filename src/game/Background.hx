package game;

/**
 * A background object, which is the scene background. This object is designed
 * to be very "responsive" and should fit most resolutions. The idea is that the
 * same background file should be used for a desktop and mobile environment.
 * 
 * This is achieved by making a small square of "important" visual information and
 * the a huge bleed around the center area that isn't as important but helps "fill"
 * the rest of the information.
 */
class Background extends h2d.Object {

	public function new(background : Data.BackgroundsKind, ?parent : h2d.Scene) {
		super(parent);

		// loads the data from the CDB
		var backgroundData = Data.backgrounds.get(background);

		// makes the tile from the defined image file.
		var t = hxd.Res.load(backgroundData.image.file).toTile();

		// makes the bitmap object and centers it to 0,0 so that
		// we don't need to touch it anymore.
		var b = new h2d.Bitmap(t,this);
		b.x = -backgroundData.center.x;
		b.y = -backgroundData.center.y;

	}

	/**
	 * Resize the background inside the container.
	 * @param w container width
	 * @param h container height
	 */
	public function resize(w : Int, h : Int) {

		// determines the scale that we should be using using the constant
		// defined IDEAL WIDTH AND HEIGHT.
		var scale = Math.min(w / Const.IDEALWIDTH, h / Const.IDEALHEIGHT);
		setScale(scale);

		// centers the background in the window.
		x = w /2;
		y = h / 2;

	}
}