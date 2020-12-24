package game;

import haxe.display.Display.Package;

private typedef Time = { period : Int, slot : Int };

class Clock extends h2d.Object {

	//////////////////////////////////////////////////////////////////////////
	// private members

	private var sprite : h2d.Anim;
	private var shader : shader.Highlight;
	
	//////////////////////////////////////////////////////////////////////////
	// public members

	public var width(get, null) : Float;
	private function get_width() : Float return sprite.frames[0].width * sprite.scaleX;

	public var height(get, null) : Float;
	private function get_height() : Float return sprite.frames[0].height * sprite.scaleY;
	
	//////////////////////////////////////////////////////////////////////////
	// public members

	public function new(?parent : h2d.Object) {
		super(parent);

		initalize();

		// moves the object to where it should always be on the screen.
		x = Const.CLOCK_SCREEN_PADDING + width / 2;
		var oy = y = Const.CLOCK_SCREEN_PADDING + height / 2;

		// creates the over shader
		shader = new shader.Highlight(0.25);

		// creates the interactive so we get some feedback from the clock and know what its
		// there for.
		var interactive = new h2d.Interactive(width, height, this);
		interactive.x = -width / 2;
		interactive.y = -height / 2;
		interactive.onOver = onOver;
		interactive.onOut = onOut;
		interactive.onClick = onClick;

		// creates the idle bobbing animation to give it a little more life.
		// if that option is enabled.
		if (Const.CLOCK_IDLE) {
			var idleTimer = new sn.Timer(Const.CLOCK_IDLE_PERIOD, true);
			idleTimer.infinite = true;
			idleTimer.updateCallback = function() {
				y = oy + Const.CLOCK_IDLE_STRENGTH * Math.cos(2 * Math.PI * idleTimer.timerPercent);
			}
		}

		// testing setting etc ... delete me.
		setTime(3,1);
		getTime();
		
	}

	//////////////////////////////////////////////////////////////////////////
	// private functions

	private function initalize() {

		// hardcoded loads all the frames ...
		var tiles : Array<h2d.Tile> = [];
		tiles.push(hxd.Res.clock.sun_11.toTile());
		tiles.push(hxd.Res.clock.sun_12.toTile());
		tiles.push(hxd.Res.clock.sun_21.toTile());
		tiles.push(hxd.Res.clock.sun_22.toTile());
		tiles.push(hxd.Res.clock.sun_31.toTile());
		tiles.push(hxd.Res.clock.sun_32.toTile());
		tiles.push(hxd.Res.clock.sun_41.toTile());
		tiles.push(hxd.Res.clock.sun_42.toTile());
		tiles.push(hxd.Res.clock.sun_51.toTile());
		tiles.push(hxd.Res.clock.sun_52.toTile());
		tiles.push(hxd.Res.clock.sun_61.toTile());
		tiles.push(hxd.Res.clock.sun_62.toTile());

		// creates the animation, we are using an animation object
		// to contain all the tiles, but we are actually not animating
		// it at all.
		sprite = new h2d.Anim(tiles);
		addChild(sprite);
		sprite.setScale(Const.CLOCK_SCALE);

		// we scale and move it so that it is at the center of this
		// new clock object.
		sprite.x = -tiles[0].width / 2 * sprite.scaleX;
		sprite.y = -tiles[0].height / 2 * sprite.scaleY;

		// sets it for the first day, first period.
		sprite.pause = true;
		sprite.currentFrame = 0;
	}

	private function onOver(e : hxd.Event) {
		sprite.addShader(shader);
	}

	private function onOut(e : hxd.Event) {
		sprite.removeShader(shader);
	}

	private function onClick(e : hxd.Event) {
		var periodName = getPeriodName();
		var left = 3 - getTime().slot;
		var locations = if (left == 1) "location"; else "locations";
		Game.createDialoge('It\'s ~$periodName~, looks like I still have time to visit *$left* more $locations.', x, y, width * 0.5);
	}

	/**
	 * Sets the period and slot for the current time, periods are between 1-6
	 * and slots are 1-2.
	 * 
	 * Time progress like: 1.1, 1.2, 2.1, 2.2, etc ...
	 * @param period 
	 * @param slot 
	 */
	private function setTime(period : Int, slot: Int) {

		var desiredFrame = (period - 1) * 2 + (slot - 1);
		sprite.currentFrame = desiredFrame;

	}

	private function getPeriodName() : String {
		switch(getTime().period) {
			case 1: return "Early Morning";
			case 2: return "Late Morning";
			case 3: return "Early Afternoon";
			case 4: return "Late Afternoon";
			case 5: return "Early Evening";
			case 6: return "Late Evening";
			case _: return "NO IDEA!";
		}
	}

	private function getTime() : Time {
		var frame = Math.ceil(sprite.currentFrame);
		
		var period = Math.floor(frame / 2) + 1;
		var slot = frame - (period - 1) * 2 + 1;

		return { period: period, slot: slot };
	}
}