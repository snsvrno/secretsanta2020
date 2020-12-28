import game.ui.Icon;
import h3d.scene.Graphics;
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

	inline static public var UI_BOXES_ICONS : Bool = false;
	inline static public var UI_BOXES_TEXT : Bool = false;

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
			case(hxd.Key.F6):
				var test = testUiElements();
				Game.debugAddToScene(test);
			case(hxd.Key.Q): Game.debugTickClick(-1);
			case(hxd.Key.W): Game.debugTickClick(1);
			case _:
		} 
	}

	static public function testUiElements() : h2d.Object {
		var test = new h2d.Object();

		var background = new h2d.Graphics(test);
		background.beginFill(0x000000,0.8);
		background.drawRect(0,0,Const.WORLD_WIDTH,Const.WORLD_HEIGHT);
		background.endFill();

		background.lineStyle(1, 0xFF0000,1);

		/////////////////////////
		// Text objects

		var horizontal : Array<game.ui.alignment.Horizontal> = [ Left, Center, Right ];
		var vertical : Array<game.ui.alignment.Vertical> = [ Top, Middle, Bottom ];

		for (h in 0 ... horizontal.length) {
			for (v in 0 ... vertical.length) {
				var text = new game.ui.Text('${horizontal[h]}-${vertical[v]}', test);
				text.setScale(0.5);
				text.x = 10 + 160 * h;
				text.y = 10 + 20 * v;
				text.setAlignment(horizontal[h], vertical[v]);

				background.drawCircle(text.x, text.y, 3);
			}
		}			

		/////////////////////////
		// ICONS		
		var tile = hxd.Res.load(Data.items.get(sparetire).icon).toTile();
		for (h in 0 ... horizontal.length) {
			for (v in 0 ... vertical.length) {
				var icon = new game.ui.Icon(tile, test);
				icon.x = 10 + 75 * h;
				icon.y = 100 + 75 * v;
				icon.setAlignment(horizontal[h], vertical[v]);

				background.drawCircle(icon.x, icon.y, 3);
			}
		}			

		return test;
	}
}