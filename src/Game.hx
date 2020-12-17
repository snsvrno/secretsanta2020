
class Game extends hxd.App {

	//////////////////////////////////////////////////////////////////////////
	// static variables

	static public var variables : game.Variables;

	//////////////////////////////////////////////////////////////////////////
	// member variables

	/**
	 * The object that contains all the actors and props
	 * for the current interactive scene. There might not be
	 * anything loaded though. The scene is like one of the
	 * "locations" on the map. The map isn't a scene.
	 */
	private var activeScene : game.Scene;

	override function init() {

		//////////////////////////////////////////////////////////////////////////
		// some presetup.

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

		// creates the scene object, which contains all the actors.
		// and props
		activeScene = new game.Scene(s2d);
		activeScene.load(garage);

		// creates the corner border thing.
		game.utils.Corners.make(s2d);

		//////////////////////////////////////////////////////////////////////////
		// setup the position of the scene so its centered
		onResize();

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
}