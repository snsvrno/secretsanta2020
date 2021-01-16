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
	public static var console : h2d.Console;

	static public function initalize(parent : h2d.Object) {
		console = new h2d.Console(hxd.Res.fonts.edi32.toFont(), parent);
		console.addCommand(
			"switch", null, [{ t: AString, opt: false, name: "name" }],
			function(name:String) {
				var localColor = if (Game.variables.check(name)) 0x00FF00 else 0xFF0000;
				var lifetimeColor = if (Game.variables.check("*" + name)) 0x00FF00 else 0xFF0000;
				console.log('${name}: local', localColor);
				console.log('${name}: lifetime', lifetimeColor);
			}
		);
		console.addCommand(
			"set", null, [{ t: AString, opt: false, name: "name" }, { t : ABool, opt: false, name : "value"}],
			function(name : String, value : Bool) {
				Game.variables.setSwitch(name, value);
			}
		);
		console.addCommand(
			"value", null, [{ t: AString, opt: true, name: "name" }, { t : AInt, opt: true, name : "value"}],
			function(?name : String, ?value : Int) {
				if (name == null) {
					for (v in Game.variables.getValues())
						console.log('$v : ${Game.variables.getValue(v)}');
				} else if (value == null) {
					console.log('$name : ${Game.variables.getValue(name)}');
				} else {
					Game.variables.setValue(name, value);
					console.log('$name : ${Game.variables.getValue(name)}');
				}
			}
		);
	}

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
		interactive.cursor = hxd.Cursor.Default;
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
			case(hxd.Key.F1): 
				console.show();
			case(hxd.Key.F2): Debug.toggleDisplayItems();
			case(hxd.Key.F3): Game.foundItem(sparetire);
			case(hxd.Key.F4): Game.lostItem(sparetire);
			case(hxd.Key.F5): Game.debugGameOverScreen();
			case(hxd.Key.F6):
				var test = testUiElements();
				Game.debugAddToScene(test);
			case(hxd.Key.F7):
				var test = testTextElements();
				Game.debugAddToScene(test);
			case(hxd.Key.F8):
				Game.popup("you now have all items.");
				for (i in Data.items.all) Game.variables.gets(i.name);
			case(hxd.Key.Q): Game.debugTickClick(-1);
			case(hxd.Key.W): Game.debugTickClick(1);
			case _:
		} 
	}

	static public function testTextElements() : h2d.Object {
		var test = new h2d.Object();
		test.name = "debugcover";

		var background = new h2d.Graphics(test);
		background.beginFill(0x000000,0.8);
		background.drawRect(0,0,Const.WORLD_WIDTH,Const.WORLD_HEIGHT);
		background.endFill();

		var sampeltext = "This is some *long* text, /to/ _test_ the ~word wrap~";
		//var sampeltext = "This is some long text, to test the word wrap";

		var graphics = new h2d.Graphics();
		graphics.lineStyle(2, 0x00FF00);

		var padding = 3;
		var y = 0.;
		for (tw in [null, 100, 200]) {
			var text = game.dialogue.Bubble.manual(sampeltext, Const.WORLD_WIDTH / 2,0, tw);
			test.addChild(text);
			text.y = y + text.height/2 + padding;

			graphics.drawRect(Const.WORLD_WIDTH / 2 - tw/2, text.y - tw/2, tw, tw);
			
			y = text.y + text.height/2 + padding;
		}

		test.addChild(graphics);


		return test;
	}

	static public function testUiElements() : h2d.Object {
		var test = new h2d.Object();
		test.name = "debugcover";

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