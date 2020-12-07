package game;

class Transition extends h2d.Bitmap {
	
	public var onFinish : Null<() -> Void>;

	private var scene : h2d.Scene;
	private var timer : sn.Timer;	
	private var shader : shader.Wipe;

	public function new(parent : h2d.Scene) {
		super(parent);
		scene = parent;

		shader = new shader.Wipe();

		// makes the actual transition timer.
		timer = new sn.Timer(Const.WIPETRANSITIONDURATION, true);
		timer.updateCallback = function() shader.progress = timer.timerPercent;
		timer.finalCallback = function() { 
			shader.progress = 0;
			alpha = 0;
			removeShader(shader);
			if (onFinish != null) onFinish();
		}
		timer.stop();
	}

	public function transition(?beforeStart : () -> Void) {

		// captures the current scene and renders it to a bitmap.
		var bitmap = scene.captureBitmap();
		if (tile != null) tile.dispose();
		tile = bitmap.tile;

		// adds the shader and gets ready for stuff.
		addShader(shader);
		alpha = 1;

		// runs whatever needs to be done before we start the transition effect.
		if (beforeStart != null) beforeStart();

		timer.reset();
	}
}