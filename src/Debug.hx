class Debug {

	private static var displayItemsState : Bool = false;
	public static var displayItems : Array<h2d.Object> = [];

	static public function toggleDisplayItems(?state : Bool) {

		if (state == null) displayItemsState = !displayItemsState;
		else displayItemsState = state;

		for (d in displayItems) {
			if (displayItemsState) d.alpha = 1;
			else d.alpha = 0;
		}

	}

	static public function mouseCoordinatesOverlay(s2d : h2d.Scene) {

		var interactive = new h2d.Interactive(Const.WORLDWIDTH, Const.WORLDHEIGHT, s2d);
		interactive.propagateEvents = true;

		var font = hxd.res.DefaultFont.get();
		var xc = new h2d.Text(font, interactive);

		interactive.onMove = function(e : hxd.Event) {
			xc.text = '${Math.floor(e.relX / Const.WORLDWIDTH * 100) / 100}, ${Math.floor(e.relY / Const.WORLDHEIGHT * 100) / 100}';
			xc.x = e.relX;
			xc.y = e.relY;
		};
	}

	static public function warning(s2d : h2d.Scene) {
		var font = hxd.res.DefaultFont.get();
		var warningtext = new h2d.Text(font, s2d);
		warningtext.text = "DEBUG ENABLED!";
		warningtext.alpha = 0.20;
		warningtext.setScale(10);
		warningtext.maxWidth = Const.WORLDWIDTH / warningtext.scaleX;
		warningtext.x = Const.WORLDWIDTH / 2 - warningtext.textWidth * warningtext.scaleX / 2;
		warningtext.y = Const.WORLDHEIGHT / 2 - warningtext.textHeight * warningtext.scaleY / 2;
	}
}