
class Game extends hxd.App {

	//////////////////////////////////////////////////////////////////////////
	// static variables

	static public var variables : game.Variables;
	static private var instance : Game;
	static public function changeScene(newScene : Data.ScenesKind) instance.changeToScene(newScene);
	static public function toMap() instance.changeToMap();
	static public function foundItem(item : Data.ItemsKind) game.Popup.item(item, true, instance.s2d);
	static public function lostItem(item : Data.ItemsKind) game.Popup.item(item, false, instance.s2d);

	//////////////////////////////////////////////////////////////////////////
	// member variables

	/**
	 * The object that contains all the actors and props
	 * for the current interactive scene. There might not be
	 * anything loaded though. The scene is like one of the
	 * "locations" on the map. The map isn't a scene.
	 */
	private var activeScene : game.Scene;

	private var map : game.map.Map;

	private var ui : game.Interface;

	override function init() {

		//////////////////////////////////////////////////////////////////////////
		// some presetup.

		Game.instance = this;

		// setup the resources
		sn.Window.initResources();
		Const.initalize();

		// initalizes the variables and loads saved status if applicable.
		Game.variables = new game.Variables();

		// setting some window options
		var window = hxd.Window.getInstance();
		// makes the window title.
		window.title = sn.Window.generateTitle(Const.GAMETITLE);

		// set the background color
		engine.backgroundColor = Const.BACKGROUNDCOLOR;

		//////////////////////////////////////////////////////////////////////////
		// loads the components

		// creates the 'background' of the game
		var background = new h2d.Graphics(s2d);
		background.beginFill(Const.WORLDBACKGROUNDCOLOR);
		background.drawRect(0, 0, Const.WORLDWIDTH, Const.WORLDHEIGHT);
		background.endFill();

		map = new game.map.Map(s2d);

		// creates the scene object, which contains all the actors.
		// and props
		activeScene = new game.Scene(s2d);
		activeScene.load(blank); // bug that this will not compile unless there is a load, not sure why...

		// add the interface UI
		ui = new game.Interface(s2d);

		// creates the corner border thing.
		game.utils.Corners.make(s2d);

		//////////////////////////////////////////////////////////////////////////
		// setup the position of the scene so its centered
		onResize();

		// gets us ready to go to map.
		toMap();

		// adds debug stuff if we are in debug build.
		#if debug
		Debug.mouseCoordinatesOverlay(s2d);
		Debug.warning(s2d);
		#end
	}

	override function update(dt:Float) {
		super.update(dt);
		sn.Timer.update(dt);
	}

	override function onResize() {
		super.onResize();

		var window = hxd.Window.getInstance();

		//////////////////////////////////////////////////////////////////////////
		// calculating the s2d scene resize stuff.
		// gets the resize value, and adds padding on the edges.
		var scale = Math.min((window.width - 2 * Const.SCREENPADDING) / Const.WORLDWIDTH, (window.height - 2 * Const.SCREENPADDING) / Const.WORLDHEIGHT);
		s2d.setScale(scale);
		// offsets the scene so its in the center.
		s2d.x = window.width/2 - Const.WORLDWIDTH/2 * scale;
		s2d.y = window.height/2 - Const.WORLDHEIGHT/2 * scale;
	}

	private function changeToScene(newScene : Data.ScenesKind) {
		
		// sets up the scene
		activeScene.load(newScene);
		activeScene.enable();

		// disables the background
		map.disable();

		ui.setLocationName(activeScene.sceneName);
		ui.onScene();
	}

	private function changeToMap() {
		ui.onMap();
		map.enable();
		activeScene.disable();
	}
}