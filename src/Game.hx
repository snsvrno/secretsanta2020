class Game extends hxd.App {

	var overmap : map.Map;

	override function init() {
		sn.Window.initResources();

		// setting some window options
		var window = hxd.Window.getInstance();
		// makes the window title.
		window.title = sn.Window.generateTitle(Const.GAMETITLE);

		// loads the game map
		overmap = new map.Map(main, s2d);

		onResize();
	}
	
	override function onResize() {
		
		var window = hxd.Window.getInstance();

		overmap.resize(window.width, window.height);

	}

}