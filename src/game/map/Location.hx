package game.map;

import h2d.Interactive;

class Location extends h2d.Object {

	private var iconWidth : Float;
	private var iconHeight : Float;

	public var bitmap : h2d.Bitmap;

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
		bitmap = new h2d.Bitmap(t, this);
		bitmap.x = -data.center.x;
		bitmap.y = -data.center.y;

		// resizes the icon. we only need to do this here because the location
		// is inside the map which resizes.
		resize(Const.IDEALICONSIZE);
		
		// the highlighter shader.
		hoverShader = new shader.Highlight(0);
		bitmap.addShader(hoverShader);

		var enableTimer = new sn.Timer(Const.LOCATIONMOUSEOVERLENGTH, true);
		enableTimer.updateCallback = function() hoverShader.intensity = Const.LOCATIONMOUSEOVERINTENSITY * enableTimer.timerPercent;
		enableTimer.finalCallback = function() hoverShader.intensity = Const.LOCATIONMOUSEOVERINTENSITY;
		enableTimer.stop();

		var disableTimer = new sn.Timer(Const.LOCATIONMOUSEOVERLENGTH, true);
		disableTimer.updateCallback = function() hoverShader.intensity = Const.LOCATIONMOUSEOVERINTENSITY * (1 - disableTimer.timerPercent);
		disableTimer.finalCallback = function() hoverShader.intensity = 0;
		disableTimer.stop();

		// creates an interactive and covers the area with it.
		var interactive = new h2d.Interactive(iconWidth, iconHeight, this);
		interactive.x = -iconWidth / 2;
		interactive.y = -iconHeight / 2;
		interactive.onOver = function(e) {
			disableTimer.reset();
			disableTimer.stop();
			enableTimer.reset();
		}
		interactive.onOut = function(e) { 
			enableTimer.reset();
			enableTimer.stop();
			disableTimer.reset();
		}
	}

	public function resize(side : Float) {

		// determines the scale that we should be using using the constant
		// defined IDEAL WIDTH AND HEIGHT.
		var scale = Math.min(side / iconHeight, side / iconWidth);
		setScale(scale);

	}
}