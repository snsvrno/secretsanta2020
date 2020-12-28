import hxd.res.DynamicText.Key;

class Debug {

	////////////////////////////////////////////////////////////////////////////////////////
	// DEBUG OPTION SWITCHES, THESE DON'T DO ANYTHING UNLESS BUILT IN DEBUG MODE.
	// MOST OF THESE NEED TO BE ON DURING BUILD TO DO ANYHTING, THEY ARE TRIGGERED DURING
	// INITALIZATION OF ITEMS AND NOT DURING THE UPDATE LOOP.

	/** shows a boundary around bubble.text individual text objects. */
	inline static public var TEXT_SHOW_BOUNDARIES : Bool = false;
	/** shows a boundary around bubble.text objects. */
	inline static public var TEXTBOX_SHOW_BOUNDARIES : Bool = false;

	////////////////////////////////////////////////////////////////////////////////////////

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

		var interactive = new h2d.Interactive(Const.WORLD_WIDTH, Const.WORLD_HEIGHT, s2d);
		interactive.propagateEvents = true;

		var font = hxd.res.DefaultFont.get();
		var xc = new h2d.Text(font, interactive);

		interactive.onMove = function(e : hxd.Event) {
			xc.text = '${Math.floor(e.relX / Const.WORLD_WIDTH * 100) / 100}, ${Math.floor(e.relY / Const.WORLD_HEIGHT * 100) / 100}';
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
		warningtext.maxWidth = Const.WORLD_WIDTH / warningtext.scaleX;
		warningtext.x = Const.WORLD_WIDTH / 2 - warningtext.textWidth * warningtext.scaleX / 2;
		warningtext.y = Const.WORLD_HEIGHT / 2 - warningtext.textHeight * warningtext.scaleY / 2;
	}

	static public function onEvent(e : hxd.Event) {
		if (e.kind == EKeyDown) switch(e.keyCode) {
			case(hxd.Key.F2): Debug.toggleDisplayItems();
			case(hxd.Key.F3): Game.foundItem(sparetire);
			case(hxd.Key.F4): Game.lostItem(sparetire);
			case(hxd.Key.F5): Game.debugGameOverScreen();
			case(hxd.Key.Q): Game.debugTickClick(-1);
			case(hxd.Key.W): Game.debugTickClick(1);
			case _:
		} 
	}
}