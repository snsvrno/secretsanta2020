package map;

import h2d.Interactive;

class Location extends h2d.Object {

	private var iconWidth : Float;
	private var iconHeight : Float;

	private var hoverShader : shader.Highlight;
	
	public function new(definition : Data.Overmap_locations, ?parent : h2d.Object) {
		super(parent);

		// gets the definition for the location.
		var data = Data.locations.get(definition.locationId);

		// creates a tile from the defined image.
		var t = hxd.Res.load(data.icon).toTile();
		iconWidth = t.width;
		iconHeight = t.height;

		// makes the bitmap, adds it and centers it.
		var b = new h2d.Bitmap(t, this);
		b.x = -data.center.x;
		b.y = -data.center.y;

		// resizes the icon. we only need to do this here because the location
		// is inside the map which resizes.
		resize(Const.IDEALICONSIZE);
		
		// the highlighter shader.
		hoverShader = new shader.Highlight(0.5);
		
		// creates an interactive and covers the area with it.
		var interactive = new h2d.Interactive(iconWidth, iconHeight, this);
		interactive.x = -iconWidth / 2;
		interactive.y = -iconHeight / 2;
		interactive.onOver = function(e) b.addShader(hoverShader);
		interactive.onOut = function(e) b.removeShader(hoverShader);

	}

	public function resize(side : Float) {

		// determines the scale that we should be using using the constant
		// defined IDEAL WIDTH AND HEIGHT.
		var scale = Math.min(side / iconHeight, side / iconWidth);
		setScale(scale);

	}
}