package game.map;

class Map extends h2d.Object {
	private var background : h2d.Bitmap;
	private var locations : Array<Location> = [];
	private var shaderDisabled : shader.Darken;

	private var currentLocationText : h2d.Text;

	/** an overlay graphics color that is suppose to emulate sun lighting */
	private var lightingLayer : h2d.Graphics;

	public function new(?parent : h2d.Object) {
		super(parent);

		var tile = hxd.Res.map.base.toTile();
		background = new h2d.Bitmap(tile, this);

		for (l in Data.locations.all) {
			var location = new Location(l, this);
			location.setLocationText = setLocationText;
			locations.push(location);
		}
	
		// need to add this so the layer "compacts" or "flattens" all
		// the elements and the alpha works as expected.
		filter = new h2d.filter.Nothing();
		shaderDisabled = new shader.Darken(Const.LOCATION_UNACCESSABLE_ALPHA);
		
		// for lighting effects.
		lightingLayer = new h2d.Graphics(this);

		currentLocationText = new h2d.Text(Const.MAP_LOCATION_FONT, this);
		currentLocationText.alpha = 0;
		currentLocationText.filter = new h2d.filter.DropShadow(0, 0, 0, 1, 0.5);
		currentLocationText.setScale(Const.LOCATION_TEXT_SIZE);
	}

	public function setLocationText(?text : String, ?x : Float, ?y : Float) {
		if (text == null) currentLocationText.alpha = 0;
		else currentLocationText.alpha = 1;

		currentLocationText.text = text;
		currentLocationText.x = x - currentLocationText.textWidth/2;
		currentLocationText.y = y - currentLocationText.textHeight/2;
		addChild(currentLocationText);
	}

	public function enable() {
		alpha = 1.0;

		for (l in locations) l.enable();
		updateLocationIcons();
	}

	public function disable() {
		alpha = Const.MAP_DISABLED_OPACITY;

		for (l in locations) l.disable();
	}

	public function updateLocationIcons() {
		for (l in locations) l.updateIcons();
	}

	public function setLighting(clock : game.Clock) {

		var pslot = clock.period * 2 + clock.slot;

		// choose what color to use based on the period.
		var color : Int = Const.MAP_AFTERNOON_COLOR;
		if(clock.period <= 2) color = Const.MAP_MORNING_COLOR;
		else if(clock.period >= 5) color = Const.MAP_EVENING_COLOR;

		var mid = Math.floor(Const.CLOCK_PERIODS * Const.CLOCK_SLOTS);
		var alpha = if (pslot <= mid) {
			(Const.MAP_PEAK_OPACITY - Const.MAP_FRINGE_OPACITY) / mid * pslot + Const.MAP_FRINGE_OPACITY;
		} else {
			(Const.MAP_FRINGE_OPACITY - Const.MAP_PEAK_OPACITY) / mid * (pslot - mid) + Const.MAP_PEAK_OPACITY;
		}

		lightingLayer.clear();
		lightingLayer.beginFill(color, alpha);
		lightingLayer.drawRect(0, 0, Const.WORLD_WIDTH, Const.WORLD_HEIGHT);
		lightingLayer.endFill();
	}

	public function disableInaccessableLocations(visits : Array<String>) {
		for (l in locations) if (!visits.contains(l.data.name)) l.notAccessable();
		background.addShader(shaderDisabled);

	}

	public function resetAllInaccessableLocations() {
		for (l in locations) l.notAccessable(true);
		background.removeShader(shaderDisabled);
	}
}