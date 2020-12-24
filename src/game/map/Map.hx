package game.map;

class Map extends h2d.Object {
	private var locations : Array<Location> = [];

	/** an overlay graphics color that is suppose to emulate sun lighting */
	private var lightingLayer : h2d.Graphics;

	public function new(?parent : h2d.Object) {
		super(parent);

		var tile = hxd.Res.map.base.toTile();
		new h2d.Bitmap(tile, this);

		for (l in Data.locations.all) locations.push(new Location(l, this));
	
		// need to add this so the layer "compacts" or "flattens" all
		// the elements and the alpha works as expected.
		filter = new h2d.filter.Nothing();
		
		// for lighting effects.
		lightingLayer = new h2d.Graphics(this);
	}

	public function enable() {
		alpha = 1.0;

		for (l in locations) l.enable();
	}

	public function disable() {
		alpha = Const.MAP_DISABLED_OPACITY;

		for (l in locations) l.disable();
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
}