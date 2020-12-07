package game.map;

class Map extends h2d.Object {

	var locations : Array<Location> = new Array();
	var backgroundBitmap : h2d.Bitmap;

	public function new(mapname : Data.OvermapKind, ?parent : h2d.Scene) {
		super(parent);

		// loads the data from the CDB
		var data = Data.overmap.get(mapname);

		// creates a tile from the defined image.
		var t = hxd.Res.load(data.image).toTile();

		// makes the bitmap, adds it and centers it.
		backgroundBitmap = new h2d.Bitmap(t, this);
		backgroundBitmap.x = -t.width / 2;
		backgroundBitmap.y = -t.height / 2;

		// makes all the locations.
		for (def in data.locations) {
			var loc = new Location(def, this);
			// we need to offset it based on how we are offsetting the map.
			loc.x = def.x + backgroundBitmap.x;
			loc.y = def.y + backgroundBitmap.y;
			// adds it for tracking?
			locations.push(loc);
		}
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