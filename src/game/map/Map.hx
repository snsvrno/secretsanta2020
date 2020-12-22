package game.map;

class Map extends h2d.Object {
	private var locations : Array<Location> = [];

	public function new(?parent : h2d.Object) {
		super(parent);

		var tile = hxd.Res.map.base.toTile();
		var background = new h2d.Bitmap(tile, this);

		for (l in Data.locations.all) locations.push(new Location(l, this));
	}

	public function enable() {
		alpha = 1.0;

		for (l in locations) l.enable();
	}

	public function disable() {
		alpha = Const.WORLDBACKGROUNDDISABLEDOPACTIY;

		for (l in locations) l.disable();
	}
}