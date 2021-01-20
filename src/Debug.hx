import format.swf.Data.GradRecord;
import game.ui.Icon;

class Debug {

	////////////////////////////////////////////////////////////////////////////////////////
	// DEBUG OPTION SWITCHES, THESE DON'T DO ANYTHING UNLESS BUILT IN DEBUG MODE.
	// MOST OF THESE NEED TO BE ON DURING BUILD TO DO ANYHTING, THEY ARE TRIGGERED DURING
	// INITALIZATION OF ITEMS AND NOT DURING THE UPDATE LOOP.

	inline static public var TEXT_SHOW_BOUNDARIES : Bool = false;
	inline static public var TEXTBOX_SHOW_BOUNDARIES : Bool = false;
	inline static public var UI_BOXES_ICONS : Bool = false;
	inline static public var UI_BOXES_TEXT : Bool = false;

	////////////////////////////////////////////////////////////////////////////////////////

	private static var scene : h2d.Object;

	public static var displays : Map<String, Array<h2d.Object>> = new Map();
	public static var console : h2d.Console;

	static public function initalize(parent : h2d.Object) {
		scene = parent;

		mouseCoordinatesOverlay();
		initalizeConsole();
	}

	static private function initalizeConsole() {
		console = new h2d.Console(hxd.Res.fonts.edi32.toFont(), scene);
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

	static public function mouseCoordinatesOverlay() {

		var interactive = new h2d.Interactive(Const.WORLD_WIDTH, Const.WORLD_HEIGHT, scene);
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

	inline static private var waittime : Float = 1;
	inline static private var fadetime : Float = 0.15;
	/**
	 * announces a setting change.
	 * @param text 
	 */
	static private function announce(text) {

		var text = new game.ui.Text(text, null, scene);
		text.setAlignment(Center, Middle);
		text.x = Const.WORLD_WIDTH / 2;
		text.y = Const.WORLD_HEIGHT / 2;

		var timer = new sn.Timer(waittime + fadetime);
		timer.updateCallback = () -> if (timer.timer > waittime) {
			text.alpha = 1 - (timer.timer - waittime) / fadetime;
		}
		timer.finalCallback = () -> text.remove();
	}

	static private function showDebugDisplays() {
		if (scene.getObjectByName("debugitemlist") != null) return;

		var screen = new h2d.Object(scene);
		screen.name = "debugitemlist";
		var interactiveBlocker = new h2d.Interactive(Const.WORLD_WIDTH, Const.WORLD_HEIGHT, screen);
		var graphic = new h2d.Graphics(screen);
		graphic.beginFill(0x000000, 0.85);
		graphic.drawRect(0,0, Const.WORLD_WIDTH, Const.WORLD_HEIGHT);
		graphic.endFill();

		var list = new game.ui.VStack(screen);
		list.x = 10;
		list.y = 10;
		list.setAlignment(Left, Top);

		var text = new game.ui.Text("DISPLAYS");
		list.push(text);

		for (k in displays.keys()) {
			var button = new game.ui.Button(k);
			button.overScale = button.normalScale;
			button.normalColor = 0xFF0000;
			var state = false;
			button.onClick = function() {
				state  = !state;
				if (state) button.normalColor = 0x00FF00;
				else button.normalColor = 0xFF0000;

				var items = displays.get(k);
				if (items != null) {
					if (state) for (i in items) i.alpha = 1;
					else for (i in items) i.alpha = 0; 
				}
			};
			list.push(button);
		}
		list.setChildrenAlignment(Left);

	}

	static private function allLocations() {
		for (i in 1 ... 7) {
			for (a in Data.characters.all) {
				if (a.icon!= null) for (l in Data.locations.all) {
					Game.variables.saw(a.id, l.id, i);
				}
			}
		}
	}

	static public function onEvent(e : hxd.Event) {
		if (e.kind == EKeyDown) switch(e.keyCode) {
			case(hxd.Key.F1): 
				console.show();
			case(hxd.Key.F2):
				showDebugDisplays();
			case(hxd.Key.F3): 
				allLocations();
				announce("gets all location markers");
			case(hxd.Key.F4): 
			case(hxd.Key.F5):
			case(hxd.Key.F6):
			case(hxd.Key.F7):
			case(hxd.Key.F8):
			case _:
		} 

		if (e.kind == EKeyUp) switch (e.keyCode) {
			case (hxd.Key.F2):
				var screen = scene.getObjectByName("debugitemlist");
				scene.removeChild(screen);
			case _:
		}
	}
}