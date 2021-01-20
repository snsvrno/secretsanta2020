package game;

import h2d.filter.Shader;
import h2d.filter.Outline;

private typedef Time = { period : Int, slot : Int };

class Clock extends h2d.Object {

	//////////////////////////////////////////////////////////////////////////
	// private members

	private var sprite : h2d.Anim;
	private var shader : shader.Highlight;
	private var interactive : h2d.Interactive;
	private var timetext : h2d.Text;
	private var lefttext : h2d.Text;
	private var blinkShader : shader.Highlight;
	private var blinkShadow : h2d.filter.DropShadow;
	/** 
	 * a saved slot so that when you travel back to the screen 
	 * and try and increment, it will not (as long as this is above 0)
	 */
	private var bankedSlots : Int = 0;
	
	//////////////////////////////////////////////////////////////////////////
	// public members

	public var width(get, null) : Float;
	private function get_width() : Float return sprite.frames[0].width * sprite.scaleX;

	public var height(get, null) : Float;
	private function get_height() : Float return sprite.frames[0].height * sprite.scaleY;

	public var period(get, null) : Int;
	private function get_period() : Int return getTime().period;

	public var slot(get, null) : Int;
	private function get_slot() : Int return getTime().slot;

	public var donePeriod(default, null) : Bool = false;
	public var completeRevolution(default, null) : Bool = false;


	//////////////////////////////////////////////////////////////////////////
	// public members

	public function new(?parent : h2d.Object) {
		super(parent);

		initalize();

		timetext = new h2d.Text(Const.TEXT_FONT_ACTION, this);
		timetext.color = h3d.Vector.fromColor(Const.CLOCK_TEXT_COLOR_MORNING);
		timetext.text = "Early\nAfternoon";
		timetext.filter = new h2d.filter.Outline(Const.CLOCK_OUTLINE_SIZE, Const.CLOCK_OUTLINE_COLOR);
		timetext.x = - timetext.textWidth / 3 * 2;

		lefttext = new h2d.Text(Const.MENU_FONT_SMALL, this);
		lefttext.setScale(0.75);
		lefttext.color = h3d.Vector.fromColor(Const.BUBBLE_TEXT_COLOR_REGULAR);
		lefttext.text = '${3 - getTime().slot} Locations Left';
		lefttext.filter = new h2d.filter.Outline(Const.CLOCK_OUTLINE_SIZE, Const.CLOCK_OUTLINE_COLOR);
		lefttext.x = timetext.x;
		lefttext.y = timetext.y + timetext.textHeight;

		// moves the object to where it should always be on the screen.
		x = Const.CLOCK_SCREEN_PADDING + width / 2;
		y = Const.CLOCK_SCREEN_PADDING + height / 2;
		var oy = sprite.y;

		// creates the over shader
		shader = new shader.Highlight(0.25);
		blinkShader = new shader.Highlight(0.25);
		blinkShadow = new h2d.filter.DropShadow(0, 0, Const.CLOCK_TEXT_COLOR_MORNING, 1, 50, 1, 1, true);

		// intesity blink shader
		var blinktimer = new sn.Timer(Const.CLOCK_ATTENTION_LENGTH, true);
		blinktimer.infinite = true;
		blinktimer.updateCallback = function() {
			var p = Math.cos(blinktimer.timerPercent * 2 * Math.PI);
			blinkShader.intensity = p * Const.CLOCK_ATTENTION_INTENSITY;
		}

		// creates the interactive so we get some feedback from the clock and know what its
		// there for.
		interactive = new h2d.Interactive(width, height, this);
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
				sprite.y = oy + Const.CLOCK_IDLE_STRENGTH * Math.cos(2 * Math.PI * idleTimer.timerPercent);
			}
		}

		// testing setting etc ... delete me.
		setTime(1,1);
		
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

	private function onOver(?e : hxd.Event) {
		sprite.addShader(shader);
	}

	private function onOut(?e : hxd.Event) {
		sprite.removeShader(shader);
	}

	private function onClick(e : hxd.Event) {

		var choices = new game.dialogue.Wheel(null, 0, 0, this);
		choices.addDialogueAction("/Wait/", choiceRest);
		choices.onLeave = function() {	
			timetext.alpha = 1;
			lefttext.alpha = 1;
			addInteractive();
		};
		
		// removes the interactive so we don't have to
		removeChild(interactive);
		// hides the text
		timetext.alpha = 0;
		lefttext.alpha = 0;
		// makes sure we don't have the highlight shader still on us.
		onOut();
	}

	private function addInteractive() {
		if (interactive.parent != this) addChild(interactive);
	}

	private function choiceRest() {
		addInteractive();
		timetext.alpha = 1;
		lefttext.alpha = 1;
		nextPeriod();
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
			case 1: return "Early\nMorning";
			case 2: return "Late\nMorning";
			case 3: return "Early\nAfternoon";
			case 4: return "Late\nAfternoon";
			case 5: return "Early\nEvening";
			case 6: return "Late\nEvening";
			case _: return "NO IDEA!";
		}
	}

	private function getPeriodColor() : h3d.Vector {
		switch(getTime().period) {
			case 1: return h3d.Vector.fromColor(Const.CLOCK_TEXT_COLOR_MORNING);
			case 2: return h3d.Vector.fromColor(Const.CLOCK_TEXT_COLOR_MORNING);
			case 3: return h3d.Vector.fromColor(Const.CLOCK_TEXT_COLOR_AFTERNOON);
			case 4: return h3d.Vector.fromColor(Const.CLOCK_TEXT_COLOR_AFTERNOON);
			case 5: return h3d.Vector.fromColor(Const.CLOCK_TEXT_COLOR_EVENING);
			case 6: return h3d.Vector.fromColor(Const.CLOCK_TEXT_COLOR_EVENING);
			case _: return h3d.Vector.fromColor(0xFF000000);
		}
	}

	private function getTime() : Time {
		var frame = Math.ceil(sprite.currentFrame);
		
		var period = Math.floor(frame / 2) + 1;
		var slot = frame - (period - 1) * 2 + 1;

		return { period: period, slot: slot };
	}

	/**
	 * Pushes through the slots, if we don't have any more slots then this doesn't
	 * do anything.
	 */
	public function step() {

		// if we gave a banked slot then we don't step at this point
		if (bankedSlots > 0) {
			bankedSlots--;
			return;
		}

		if (slot < Const.CLOCK_SLOTS) increment();
		else if (!donePeriod) donePeriod = true;
		
		onStep();
	}

	public function stepBack() {
		if (donePeriod) donePeriod = false;
		else increment(-1);
		onStep();
	}

	private function onStep() {
		// updates the name
		timetext.text = getPeriodName();
		timetext.color = getPeriodColor();
		
		var left = 3 - getTime().slot;
		if (donePeriod) lefttext.text = 'No Locations Left';
		else if (left == 1) lefttext.text = '$left Location Left';
		else lefttext.text = '$left Locations Left';

		// sets the blink shader so we know to focus on the clock
		if (donePeriod) {
			while(sprite.removeShader(blinkShader)) { /*a loop to ensure we remove all of them */ };
			sprite.addShader(blinkShader);
			sprite.filter = blinkShadow;
		} else {	
			// if we are not done then remove this shader.
			while(sprite.removeShader(blinkShader)) { };
			sprite.filter = null;
		}
	}

	/**
	 * Moves the clock back to 1-1
	 */
	public function restart() { 
		setTime(1,1);
		donePeriod = false;
		completeRevolution = false;
	}

	public function addSlot(count : Int) bankedSlots += count;

	/**
	 * Moves the clock to the next period regardless of the slots that are left.
	 */
	public function nextPeriod() {
		donePeriod = false;
		var currentPeriod = period;
	
		while(period == currentPeriod) increment();
		onStep();

		Game.nextPeriod();
	}

	public function increment(?direction : Int = 1) {
		sprite.currentFrame += direction;

		if (sprite.currentFrame == 0) completeRevolution = true;

	}
}