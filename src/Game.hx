class Game extends hxd.App {

	var bg : game.Background;

	override function init() {
		sn.Window.initResources();

		// setting some window options
		var window = hxd.Window.getInstance();
		// makes the window title.
		window.title = sn.Window.generateTitle(Const.GAMETITLE);

		bg = new game.Background(test, s2d);

		onResize();
	}
	
	override function onResize() {
		
		var window = hxd.Window.getInstance();

		bg.resize(window.width, window.height);
	}

}