class Game extends hxd.App {
	override function init() {

		// setting some window options
		var window = hxd.Window.getInstance();
		// makes the window title.
		window.title = sn.Window.generateTitle(Const.GAMETITLE);

	}
}