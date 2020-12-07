import shader.Highlight;

class Game extends hxd.App {

	var overmap : game.map.Map;

	/**
	 * The transition graphic layer that is used for making
	 * the wipes between scenes. This will not resize when the
	 * window resizes so its important to keep in mind. but it
	 * shouldn't be an issue because no one should be resizing
	 * it that much.
	 */
	var transition : game.Transition;

	override function init() {
		sn.Window.initResources();

		// setting some window options
		var window = hxd.Window.getInstance();
		// makes the window title.
		window.title = sn.Window.generateTitle(Const.GAMETITLE);
		// adds the event checker.
		window.addEventTarget(onEvent);

		// loads the game map
		overmap = new game.map.Map(main, s2d);

		// need to make sure this is on top.
		transition = new game.Transition(s2d);

		onResize();
	}

	override function update(dt:Float) {
		super.update(dt);

		sn.Timer.update(dt);
	}
	
	override function onResize() {
		
		var window = hxd.Window.getInstance();

		overmap.resize(window.width, window.height);
	}

	private function onEvent(e : hxd.Event) {
		if (e.kind == EKeyDown) {
			transition.onFinish = function() {
				overmap.alpha = 1;
			}
			transition.transition(function() {
				overmap.alpha = 0;
			});
		}
	}
}