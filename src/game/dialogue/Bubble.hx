package game.dialogue;


/**
 * The dialogue talkie bubble.
 */
class Bubble extends h2d.Object {

	private var background : h2d.Graphics;

	private var lines : Array<Text>;
	private var pos : Int = 0;

	private var terminates : Bool = true;

	private var moreText : h2d.Text;
	private var moreTextTimer : sn.Timer;

	public var height(get, null) : Float;
	private function get_height() : Float return lines[pos].height + 2 * Const.BUBBLE_TEXT_PADDING;

	public var width(get, null) : Float;
	private function get_width() : Float return lines[pos].width + 2 * Const.BUBBLE_TEXT_PADDING;

	/**
	 * adds a special manual bubble that will disappear when the mouse moves away.
	 * 
	 * @param text 
	 * @param x 
	 * @param y 
	 * @return Bubble
	 */
	public static function manual(text : String, x : Float, y : Float, ?wrapWidth : Float) : Bubble {
		var bubble = new Bubble();
		bubble.setText(text, wrapWidth);

		bubble.x = x;
		bubble.y = y;

		var interactive = new h2d.Interactive(bubble.width, bubble.height, bubble);
		interactive.x = - bubble.width/2;
		interactive.y = - bubble.height/2;
		interactive.onOut = function(e : hxd.Event) {
			bubble.remove();
		}
		interactive.onClick = function(e : hxd.Event) {
			if (!bubble.next()) bubble.remove();
		}

		return bubble;
	}

	public function new(?dialogue : Data.Dialogue, ?parent : h2d.Object) {
		super(parent);

		// symbol to let the player know there is more dialouge coming.
		moreText = new h2d.Text(Const.ICON_FONT);
		moreText.text = String.fromCharCode(0xf0da);
		moreText.setScale(0.50);

		#if debug
		var outline = new h2d.Graphics(moreText);
		outline.lineStyle(1, 0xF0FF0F);
		outline.drawRect(0,0,moreText.textWidth, moreText.textHeight);
		#end

		moreTextTimer = new sn.Timer(Const.BUBBLE_NEXT_TIMER, true);
		moreTextTimer.infinite = true;
		moreTextTimer.updateCallback = function () {
			if (moreTextTimer.timerPercent > 0.5) moreText.alpha = (moreTextTimer.timerPercent - 0.5) / 0.5;
			else moreText.alpha = 1 - moreTextTimer.timerPercent / 0.5;
		}

		// lets us know if we will be continuing after his dialogue.
		if (dialogue.chain != null) terminates = false;
		if (dialogue.branch != null) {
			for (b in dialogue.branch) {
				if (b.condition != null && Conditions.check(b.condition)) {
					if (b.dialogue != null) terminates = false;
				} else if (b.condition == null) { 
					if (b.dialogue != null) terminates = false;
				}
			}
		}

		background = new h2d.Graphics(this);

		if (dialogue != null) setText(dialogue.text, Const.BUBBLE_MAX_WIDTH);
	}

	private function setText(text : String, ?maxWidth : Float) {

		lines = Text.parse(text, maxWidth);
		update(0);
	}

	private function update(pos : Int) {
		
		if (terminates == false || pos < lines.length - 1) {
	
			// adds symbol noting if this the end of the conversation, of if there
			// is more dialogue coming.
			if (moreText.parent != this) addChild(moreText);
			moreText.x = lines[pos].endX;
			moreText.y = lines[pos].endY - moreText.font.lineHeight/2 * moreText.scaleY;

			// if we are going to add the symbol, we need to make space for it.
			lines[pos].push("  ");

		} else {

			removeChild(moreText);

		}

		// adds the text line so it displays.
		addChild(lines[pos]);

		// adjusts the background
		setBackground();
	}

	/**
	 * Moves to the next dialogue sequence. Will return false if it was already at the last 
	 * sequence.
	 * @return Bool
	 */
	public function next() : Bool {

		if (pos == lines.length - 1) return false;
		else {

			// removes the most recently displayed text
			lines[pos].remove();

			// increments to the next line and adds it as a child
			// so it can be displayed.
			pos++;

			update(pos);

			return true;
		}
	}

	/**
	 * Creates the background pill where the text resides.
	 */
	private function setBackground() {
		background.clear();
		background.beginFill(Const.BUBBLE_BACKGROUND_COLOR, Const.BUBBLE_BACKGROUND_ALPHA);
		background.drawRoundedRect(-width/2, -height/2, width, height, Const.BUBBLE_CORNER_RADIUS);
		background.endFill();
	}

}